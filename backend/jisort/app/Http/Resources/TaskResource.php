<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description,
            'is_assigned' => $this->is_assigned,
            'progress' => $this->progress,
            'status' => $this->status,
            'created_by' => new UserResource($this->createdBy),
            'assigned_to' => UserResource::collection($this->assignedTo),
            'activities' => ActivityResource::collection($this->activities),
            'created_at' => $this->created_at->toIso8601String(),
            'updated_at' => $this->updated_at->toIso8601String(),
        ];
    }
}