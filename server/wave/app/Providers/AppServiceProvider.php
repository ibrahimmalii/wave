<?php

namespace App\Providers;

use App\Voyager\Actions\DeleteAction as ActionsDeleteAction;
use Illuminate\Support\ServiceProvider;
use App\Voyager\Actions\EditAction as ActionsEditAction;
use App\Voyager\Actions\RestoreAction as ActionsRestoreAction;
use App\Voyager\Actions\ViewAction as ActionsViewAction;
use TCG\Voyager\Actions\DeleteAction;
use TCG\Voyager\Actions\EditAction;
use TCG\Voyager\Actions\RestoreAction;
use TCG\Voyager\Actions\ViewAction;
use TCG\Voyager\Facades\Voyager;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
    
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Voyager::replaceAction(EditAction::class, ActionsEditAction::class);
        Voyager::replaceAction(DeleteAction::class, ActionsDeleteAction::class);
        Voyager::replaceAction(ViewAction::class, ActionsViewAction::class);
        Voyager::replaceAction(RestoreAction::class, ActionsRestoreAction::class);
    }
}
