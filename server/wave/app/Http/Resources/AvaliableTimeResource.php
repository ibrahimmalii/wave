<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class AvaliableTimeResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'daily_date' => $this->daily_date,
            'hours' => [
                $this->first,
                $this->second,
                $this->third,
                $this->fourth,
                $this->fifth,
                $this->sixth,
                $this->seventh,
                $this->eighth
            ]
            // 'first' => $this->first,
            // 'second' => $this->second,
            // 'third' => $this->third,
            // 'fourth' => $this->fourth,
            // 'fifth' => $this->fifth,
            // 'sixth' => $this->sixth,
            // 'seventh' => $this->seventh,
            // 'eighth' => $this->eighth
        ];
    }
}
