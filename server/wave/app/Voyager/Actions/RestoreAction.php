<?php

namespace App\Voyager\Actions;

use TCG\Voyager\Actions\DeleteAction as VoyagerRestoreAction;

class RestoreAction extends VoyagerRestoreAction
{
    public function getTitle()
    {
        return 'استرجاع';
    }

    public function getIcon()
    {
        return 'voyager-trash';
    }

    public function getPolicy()
    {
        return 'restore';
    }

    public function getAttributes()
    {
        return [
            'class'   => 'btn btn-sm btn-success pull-right restore',
            'data-id' => $this->data->{$this->data->getKeyName()},
            'id'      => 'restore-'.$this->data->{$this->data->getKeyName()},
        ];
    }

    public function getDefaultRoute()
    {
        return route('voyager.'.$this->dataType->slug.'.restore', $this->data->{$this->data->getKeyName()});
    }
}
