<?php

use App\Http\Controllers\CategoryController;
use App\Http\Controllers\PostController;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;

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

// Route::resource('posts', PostController::class);
// Route::resource('categories', CategoryController::class);

Route::resources([
    'posts' => PostController::class,
    'categories' => CategoryController::class
]);

Auth::routes();


// Route::get('/', function () {
//     return view('welcome');
// });

// Route::get('/posts', function () {
//     return view('posts.index');
// });

// Route::get('/posts/create', function () {
//     return view('posts.create');
// });

// Route::get('/posts/x', function () {
//     return view('posts.show');
// });

// Route::get('/posts/x/edit', function () {
//     return view('posts.edit');
// });

// // -----------------------------------------

// Route::get('/categories/create', function () {
//     return view('categories.create');
// });

// Route::get('/categories/x', function () {
//     return view('categories.show');
// });

// -----------------------------------------


Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
