<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    use HasFactory;

    protected $fillable = [
        'title', 'title_subtitle', 'description', 'description_subtitle'
    ];
     

    public function users()
    {
        return $this->belongsToMany(User::class);
    }
}
