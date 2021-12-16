<?php

namespace App\Voyager\Actions;

use TCG\Voyager\Actions\EditAction as VoyagerEditAction;

class EditAction extends VoyagerEditAction
{
    public function getTitle()
    {
        return 'تعديل';
    }

    public function getIcon()
    {
        return 'voyager-edit';
    }

    public function getPolicy()
    {
        return 'edit';
    }

    public function getAttributes()
    {
        return [
            'class' => 'btn btn-sm btn-primary pull-right edit',
        ];
    }

    public function getDefaultRoute()
    {
        return route('voyager.'.$this->dataType->slug.'.edit', $this->data->{$this->data->getKeyName()});
    }
}
