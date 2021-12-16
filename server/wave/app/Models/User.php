<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Twilio\Rest\Client;
use TCG\Voyager\Traits\Translatable;


class User extends \TCG\Voyager\Models\User
{
    use HasApiTokens, HasFactory, Notifiable;


    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'name', 
        'email', 
        'password', 
        'phone_number', 
        'isVerified', 
        'role_id'
    ];
    


    protected $casts = [
        'phone_verified_at' => 'datetime',
    ];



    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array
     */



    public function services()
    {
        return $this->belongsToMany(Service::class);
    }
}



