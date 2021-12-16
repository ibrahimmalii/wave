<?php

namespace App\Voyager\Actions;

use TCG\Voyager\Actions\DeleteAction as VoyagerViewAction;

class ViewAction extends VoyagerViewAction
{
    public function getTitle()
    {
        return 'عرض';
    }

    public function getIcon()
    {
        return 'voyager-eye';
    }

    public function getPolicy()
    {
        return 'read';
    }

    public function getAttributes()
    {
        return [
            'class' => 'btn btn-sm btn-warning pull-right view',
        ];
    }

    public function getDefaultRoute()
    {
        return route('voyager.'.$this->dataType->slug.'.show', $this->data->{$this->data->getKeyName()});
    }
}
