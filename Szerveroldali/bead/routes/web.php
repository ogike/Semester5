<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/items', function () {
    return view('items.index');
});

Route::get('/items/create', function () {
    return view('items.create');
});

Route::get('/items/x', function () {
    return view('items.show');
});

Route::get('/items/x/edit', function () {
    return view('items.edit');
});

// -----------------------------------------

Route::get('/labels/create', function () {
    return view('labels.create');
});

Route::get('/labels/x', function () {
    return view('labels.show');
});

// -----------------------------------------

Auth::routes();
