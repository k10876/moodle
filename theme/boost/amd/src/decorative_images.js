// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Auto check decorative image checkbox.
 *
 * @module     theme_boost/decorative_images
 * @copyright  2024 Your Name <your@email.com>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

define(['jquery'], function($) {
    'use strict';

    /**
     * Initialize the module
     */
    function init() {
        // Use a MutationObserver to detect when the image dialog is added to the DOM
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                mutation.addedNodes.forEach(function(node) {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        // Look for the presentation checkbox in the added elements
                        const presentationCheckbox = node.querySelector('input[id$="_tiny_image_presentation"]');
                        if (presentationCheckbox) {
                            // Check the checkbox and trigger the change event
                            presentationCheckbox.checked = true;
                            presentationCheckbox.dispatchEvent(new Event('change'));
                        }
                    }
                });
            });
        });

        // Start observing the document body for added nodes
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    return {
        init: init
    };
}); 