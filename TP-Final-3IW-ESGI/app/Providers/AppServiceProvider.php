<?php

namespace App\Providers;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\ServiceProvider;

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
        $maxAttempts = 10;
        $attempt = 0;

        while ($attempt < $maxAttempts) {
            try {
                DB::connection()->getPdo();
                break;
            } catch (\Exception $e) {
                $attempt++;
                sleep(5);
            }
        }

        // If we're in the Docker environment, run the migrations
        if (env('IN_DOCKER')) {
            Artisan::call('migrate:fresh', ['--seed' => true]);
        }
    }

    // ...
}
