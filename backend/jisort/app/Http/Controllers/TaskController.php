<?php

namespace App\Http\Controllers;

use App\Http\Resources\TaskResource;
use App\Models\Task;
use App\Models\Activity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class TaskController extends Controller
{
    public function getTasks(Request $request)
    {
        $user = Auth::user();
        $tasks = Task::where('created_by', $user->id)
                     ->orWhereHas('assignedTo', function ($query) use ($user) {
                         $query->where('user_id', $user->id);
                     })
                     ->with(['createdBy', 'assignedTo', 'activities.createdBy'])
                     ->get();

        return TaskResource::collection($tasks);
    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'progress' => 'integer|min:0|max:100',
            'status' => ['required', Rule::in(['pending', 'in_progress', 'completed'])],
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $task = Task::create([
            'title' => $request->title,
            'description' => $request->description,
            'progress' => $request->progress ?? 0,
            'status' => $request->status,
            'created_by' => Auth::user()->id,
            'is_assigned' => false,
        ]);

        // Create initial activity
        Activity::create([
            'task_id' => $task->id,
            'description' => 'Task created',
            'created_by' => Auth::user()->id,
        ]);

        return new TaskResource($task->load(['createdBy', 'assignedTo', 'activities.createdBy']));
    }

    public function updateTask(Request $request, Task $task)
    {
        if ($task->created_by !== Auth::user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'string|max:255',
            'description' => 'nullable|string',
            'progress' => 'integer|min:0|max:100',
            'status' => [Rule::in(['pending', 'in_progress', 'completed'])],
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $task->update($request->only(['title', 'description', 'progress', 'status']));

        // Log activity for update
        Activity::create([
            'task_id' => $task->id,
            'description' => 'Task updated',
            'created_by' => Auth::user()->id,
        ]);

        return new TaskResource($task->load(['createdBy', 'assignedTo', 'activities.createdBy']));
    }

    public function delete(Task $task)
    {
        if ($task->created_by !== Auth::user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $task->delete();

        // Log activity for deletion
        Activity::create([
            'task_id' => $task->id,
            'description' => 'Task deleted',
            'created_by' => Auth::user()->id,
        ]);

        return response()->json(['message' => 'Task deleted successfully']);
    }

    public function assign(Request $request, Task $task)
    {
        if ($task->created_by !== Auth::user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'user_ids' => 'required|array',
            'user_ids.*' => 'exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $task->assignedTo()->sync($request->user_ids);
        $task->update(['is_assigned' => !empty($request->user_ids)]);

        // Log activity for assignment
        Activity::create([
            'task_id' => $task->id,
            'description' => 'Task assigned to users: ' . implode(', ', $request->user_ids),
            'created_by' => Auth::user()->id,
        ]);

        return new TaskResource($task->load(['createdBy', 'assignedTo', 'activities.createdBy']));
    }
}