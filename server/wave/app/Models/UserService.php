<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserService extends Model
{
    use HasFactory;

    protected $fillable = [
        'service_day', 
        'service_hour', 
        'location', 
        'user_id',
        'service_id',
        'arrived_at', 
        'completed_at', 
        'service_performer'
    ];
}
