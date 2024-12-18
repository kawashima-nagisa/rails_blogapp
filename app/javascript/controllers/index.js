// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application";

import CommentsController from "./comments_controller";
application.register("comments", CommentsController);

import ModalsController from "./modals_controller";
application.register("modals", ModalsController);

import AutocompleteController from "./autocomplete_controller";
application.register("autocomplete", AutocompleteController);
import CalendarController from "./calendar_controller";
application.register("calendar", CalendarController);

import GsapController from "./gsap_controller";
application.register("gsap", GsapController);




import DropzoneController from "./dropzone_controller";
application.register("dropzone", DropzoneController);
// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
