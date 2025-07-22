<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'email' => $this->email,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'username' => $this->username,
            'phone' => $this->phone,
            'email_verified_at' => $this->email_verified_at,
            'created_at' => $this->created_at->toIso8601String(),
            'updated_at' => $this->updated_at->toIso8601String(),
            'avatar' => $this->avatar,
            'bio' => $this->bio,
            'date_of_birth' => $this->date_of_birth,
            'gender' => $this->gender,
            'address' => $this->address,
            'city' => $this->city,
            'state' => $this->state,
            'country' => $this->country,
            'postal_code' => $this->postal_code,
            'timezone' => $this->timezone,
            'language' => $this->language,
            'status' => $this->status,
            'phone_verified_at' => $this->phone_verified_at,
            'two_factor_enabled' => $this->two_factor_enabled,
            'last_login_at' => $this->last_login_at,
            'last_activity_at' => $this->last_activity_at,
            'metadata' => $this->metadata,
            'deleted_at' => $this->deleted_at,
            'full_name' => $this->full_name,
            'initials' => $this->initials,
            'avatar_url' => $this->avatar_url,
        ];
    }
}