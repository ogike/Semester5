<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;

    public function item(){
        return $this->belongsTo(Item::class, 'item_id');
    }

    public function author(){
        return $this->belongsTo(User::class, 'author_id');
    }
}
