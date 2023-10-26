// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

import Rails from '@rails/ujs'
Rails.start()

// window.bootstrap = bootstrap;

import 'bootstrap';
import { Application } from "@hotwired/stimulus";
import "./channels"
