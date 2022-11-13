@extends('layouts.app')
@section('title', 'Create label')

@section('content')
<div class="container">
    <h1>Create label</h1>
    <div class="mb-4">
        <a href="{{ route('items.index') }}"><i class="fas fa-long-arrow-alt-left"></i> Back to the homepage</a>
    </div>

    @if (Session::has('label_created'))
        <div class="alert alert-success" role="alert">
            Label ({{ Session::get('label_created') }}) successfully created!
        </div>
    @endif

    {{-- TODO: action, method --}}
    <form action="{{ route('labels.store') }}" method="POST">
        @csrf

        <div class="form-group row mb-3">
            <label for="name" class="col-sm-2 col-form-label">Name*</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="name" name="name" value="">

                @error('name')
                    <div class="text-danger">
                        {{ $message }}
                    </div>
                @enderror
            </div>
        </div>

        <div class="form-group row mb-3">
            <label for="color" class="col-sm-2 col-form-label">Color*</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="color" name="color" value="#00ee99ff">

                @error('color')
                    <div class="text-danger">
                        {{ $message }}
                    </div>
                @enderror
            </div>
        </div>

        <div class="form-check">
            <input class="form-check-input" type="checkbox" value="" id="display" checked>
            <label class="form-check-label" for="display">
              Display label
            </label>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i>Store</button>
        </div>

    </form>
</div>
@endsection
