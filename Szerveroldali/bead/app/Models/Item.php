<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    use HasFactory;

    public function labels(){
        return $this->belongsToMany(Label::class)->withTimestamps();
    }

    public function comments(){
        return $this->hasMany(Comment::class, 'item_id');
    }
}
