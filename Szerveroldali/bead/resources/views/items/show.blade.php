@extends('layouts.app')
@section('title', 'View item: ' . $item->name)

@section('content')
<div class="container">

    {{-- TODO: Session flashes --}}

    <div class="row justify-content-between">
        <div class="col-12 col-md-8">
            <h1>{{ $item->name }}</h1>

            <p class="small text-secondary mb-0">
                <i class="far fa-calendar-alt"></i>
                <span>Obtained: {{ $item->obtained }}</span>
            </p>

            <div class="mb-2">

                {{-- TODO: label styles fix --}}
                @foreach ($item->labels as $label)
                    @if ($label->display)
                        <a href="{{ route('labels.show', $label)}}" class="text-decoration-none">
                            <span style="background-color: {{$label->color}}">{{ $label->name }}</span>
                        </a>
                    @endif
                @endforeach
            </div>

            <a href="{{ route('items.index') }}"><i class="fas fa-long-arrow-alt-left"></i> Back to the homepage</a>

        </div>

        <div class="col-12 col-md-4">
            <div class="float-lg-end">

                {{-- TODO: Links, policy --}}
                <a role="button" class="btn btn-sm btn-primary" href="#"><i class="far fa-edit"></i> Edit item</a>

                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#delete-confirm-modal"><i class="far fa-trash-alt">
                    <span></i> Delete item</span>
                </button>

            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="delete-confirm-modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="staticBackdropLabel">Confirm delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    {{-- TODO: Title --}}
                    Are you sure you want to delete item <strong>N/A</strong>?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button
                        type="button"
                        class="btn btn-danger"
                        onclick="document.getElementById('delete-item-form').submit();"
                    >
                        Yes, delete this item
                    </button>

                    {{-- TODO: Route, directives --}}
                    <form id="delete-item-form" action="#" method="POST" class="d-none">

                    </form>
                </div>
            </div>
        </div>
    </div>

    <img
        id="cover_preview_image"
        {{-- TODO: Cover --}}
        src="{{ asset('images/default_post_cover.jpg') }}"
        alt="Cover preview"
        class="my-3"
    >

    {{-- Description --}}
    <div class="mt-3">
        {!! nl2br(e( $item->description)) !!}
    </div>

    {{-- Comments --}}
    <div class="mt-3">
        <h2>Comments</h2>

        {{-- TODO: időrendi sorrend --}}
        @forelse ( $item->comments->sortBy('created_at') as $comment )
            <div class="card">
                <p class="small text-secondary mb-0">
                    <i class="fas fa-user"></i>
                    <span>By {{ $comment->author ? $comment->author->name : "Unknown" }}</span>
                </p>
                <p class="small text-secondary mb-0">
                    <i class="far fa-calendar-alt"></i>
                    <span>{{ $comment->created_at }}</span>
                </p>

                <p class="card-text mt-1">{{ $comment->text }}</p>

            </div>
        @empty
            <div class="col-12">
                <div class="alert alert-warning" role="alert">
                    No comments found!
                </div>
            </div>
        @endforelse

    </div>
</div>
@endsection
