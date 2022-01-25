<?php

namespace App\Http\Resources;

use App\Models\Service;
use Illuminate\Http\Resources\Json\JsonResource;

class OfferArResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function getService($id)
    {
        $service = ServiceArabicResource::collection(Service::where('id', $id)->get());
        return $service;
    }

    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'title_subtitle' => $this->title_subtitle,
            'description_subtitle' => $this->description_subtitle,
            'paid_service_data' => $this->getService($this->paid_service_id),
            'paid_count' => $this->paid_count,
            'free_service_data' => $this->getService($this->free_service_id),
            'free_count' => $this->free_count,
        ];
    }
}
