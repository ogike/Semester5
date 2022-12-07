@extends('layouts.app')
@section('title', 'Items')

@section('content')
<div class="container">
    <div class="row justify-content-between">


        <div class="col-12 col-md-8">
            <h1>{{ $items->total() }} items for <span class="badge bg-primary">label {{ $label->name}}</span></h1>
        </div>
        <div class="col-12 col-md-4">
            <div class="float-lg-end">
                {{-- TODO: Links, policy --}}
                <a href="{{ route('items.index') }}"><i class="fas fa-long-arrow-alt-left"></i> Back to the homepage</a>

                @if (Auth::check() && Auth::user()->is_admin)
                    <a href="{{ route('labels.edit', $label) }}" role="button" class="btn btn-sm btn-primary">
                        <i class="far fa-edit"></i> Edit label
                    </a>
                @endif
{{--
                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#delete-confirm-modal">
                    <i class="far fa-trash-alt"></i> Delete label
                </button> --}}

            </div>
        </div>
    </div>

    {{-- TODO: Session flashes --}}

    <div class="row mt-3">
        <div class="col-12 col-lg-9">
            <div class="row">
                {{-- TODO: Read posts from DB --}}

                @forelse ($items as $item)
                    <div class="col-12 col-md-6 col-lg-4 mb-3 d-flex align-self-stretch">
                        <div class="card w-100">
                            <img
                                src="{{ asset('images/default_post_cover.jpg') }}"
                                class="card-img-top"
                                alt="Item cover"
                            >
                            <div class="card-body">
                                <h5 class="card-title mb-0">{{$item->name}}</h5>

                                <p class="card-text mt-1">{!! nl2br(e(substr($item->description, 0, 100)))!!}...</p>
                            </div>
                            <div class="card-footer">
                                <a href="{{ route('items.show', $item) }}" class="btn btn-primary">
                                    <span>View item</span> <i class="fas fa-angle-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                @empty
                    <div class="col-12">
                        <div class="alert alert-warning" role="alert">
                            No items found with this label!
                        </div>
                    </div>
                @endforelse
            </div>

            <div class="d-flex justify-content-center">
                {{ $items->links() }}
            </div>

        </div>
        <div class="col-12 col-lg-3">
            <div class="row">
                <div class="col-12 mb-3">
                    <div class="card bg-light">
                        <div class="card-header">
                            labels
                        </div>
                        <div class="card-body">
                            @foreach ($labels as $label)
                                <a href="{{ route('labels.show', $label) }}" class="text-decoration-none">
                                    <span style="background-color: {{$label->color}}">{{ $label->name }}</span>
                                </a>
                            @endforeach
                        </div>
                    </div>
                </div>

                <div class="col-12 mb-3">
                    <div class="card bg-light">
                        <div class="card-header">
                            Statistics
                        </div>
                        <div class="card-body">
                            <div class="small">
                                <ul class="fa-ul">
                                    <li><span class="fa-li"><i class="fas fa-user"></i></span>Users: {{$user_count}}</li>
                                    <li><span class="fa-li"><i class="fas fa-layer-group"></i></span>Labels {{ $labels->count() }}</li>
                                    <li><span class="fa-li"><i class="fas fa-file-alt"></i></span>Items: {{ $items_count }}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
@endsection
