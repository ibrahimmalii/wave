<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Queue\SerializesModels;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class MyEvent extends Model
{
    use HasFactory;
    use Dispatchable, InteractsWithSockets, SerializesModels;

  public $message;

  public function __construct($message)
  {
      $this->message = $message;
  }

  public function broadcastOn()
  {
      return ['my-channel'];
  }

  public function broadcastAs()
  {
      return 'my-event';
  }
}
