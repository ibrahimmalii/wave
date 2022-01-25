@extends('voyager::master')

@section('page_title', __('voyager::generic.'.(isset($dataTypeContent->id) ? 'edit' : 'add')).' '.$dataType->getTranslatedAttribute('display_name_singular'))

@section('css')
<meta name="csrf-token" content="{{ csrf_token() }}">
@stop

@section('page_header')
<h1 class="page-title">
    <i class="{{ $dataType->icon }}"></i>
    {{ __('voyager::generic.'.(isset($dataTypeContent->id) ? 'edit' : 'add')).' '.$dataType->getTranslatedAttribute('display_name_singular') }}
</h1>
@stop

@php
use Carbon\Carbon;
$date = Carbon::now();
$date->toDateString();
$date->addMonths(1);
@endphp

@section('content')
<div class="page-content container-fluid">
    <form class="form-edit-add" role="form" action="@if(!is_null($dataTypeContent->getKey())){{ route('voyager.'.$dataType->slug.'.update', $dataTypeContent->getKey()) }}@else{{ route('voyager.'.$dataType->slug.'.store') }}@endif" method="POST" enctype="multipart/form-data" autocomplete="off">
        <!-- PUT Method if we are editing -->
        @if(isset($dataTypeContent->id))
        {{ method_field("PUT") }}
        @endif
        {{ csrf_field() }}
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-bordered">
                    {{-- <div class="panel"> --}}
                    @if (count($errors) > 0)
                    <div class="alert alert-danger">
                        <ul>
                            @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                    @endif

                    <div class="panel-body" style="direction:rtl">
                        <div class="form-group">
                            <label for="service_type_id"> نوع الخدمة</label>
                            <select class="form-control select2" id="service_type_id" name="service_type_id">
                                @foreach (App\Models\ServiceType::all() as $locale)
                                <option value="{{ $locale['id'] }}">{{ $locale['title_subtitle'] }}</option>
                                @endforeach
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="title">العنوان باللغة الانجليزية</label>
                            <input type="text" class="form-control" id="title" name="title" value="{{ old('title', $dataTypeContent->title ?? '') }}">
                        </div>

                        <div class="form-group">
                            <label for="title_subtitle"> العنوان باللغة العربية</label>
                            <input type="text" class="form-control" id="title_subtitle" name="title_subtitle" value="{{ old('title_subtitle', $dataTypeContent->title_subtitle ?? '') }}">
                        </div>

                        <div class="form-group">
                            <label for="description">الوصف باللغة الانجليزية</label>
                            <input type="text" class="form-control" id="description" name="description" value="{{ old('description', $dataTypeContent->description ?? '') }}">
                        </div>

                        <div class="form-group">
                            <label for="description_subtitle"> الوصف باللغة العربية</label>
                            <input type="text" class="form-control" id="description_subtitle" name="description_subtitle" value="{{ old('description_subtitle', $dataTypeContent->description_subtitle ?? '') }}">
                        </div>

                        <div class="form-group">
                            <label for="small_price">السعر الصغير</label>
                            <input type="text" class="form-control" id="small_price" name="small_price" value="{{ old('small_price', $dataTypeContent->small_price ?? 100) }}">
                        </div>

                        <div class="form-group">
                            <label for="mid_price">السعر المتوسط</label>
                            <input type="text" class="form-control" id="mid_price" name="mid_price" value="{{ old('mid_price', $dataTypeContent->mid_price ?? 100) }}">
                        </div>
                        <div class="form-group">
                            <label for="large_price">السعر الكبير</label>
                            <input type="text" class="form-control" id="large_price" name="large_price" value="{{ old('large_price', $dataTypeContent->large_price ?? 100) }}">
                        </div>

                        <div class="form-group">
                            <label for="discount">الخصم</label>
                            <input type="text" class="form-control" id="discount" name="discount" value="{{ old('discount', $dataTypeContent->discount ?? 0) }}">
                        </div>

                    </div>
                </div>
            </div>

        </div>

        <button type="submit" class="btn btn-primary pull-right save">
            حفظ
        </button>
    </form>

    <iframe id="form_target" name="form_target" style="display:none"></iframe>
    <form id="my_form" action="{{ route('voyager.upload') }}" target="form_target" method="post" enctype="multipart/form-data" style="width:0px;height:0;overflow:hidden">
        {{ csrf_field() }}
        <input name="image" id="upload_file" type="file" onchange="$('#my_form').submit();this.value='';">
        <input type="hidden" name="type_slug" id="type_slug" value="{{ $dataType->slug }}">
    </form>
</div>
@stop

@section('javascript')
<script>
    $('document').ready(function() {
        $('.toggleswitch').bootstrapToggle();
    });
</script>
@stop