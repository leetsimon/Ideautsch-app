/* ============================================
   ARTYBLANC — Main JavaScript
   Premium interactions, scroll effects, luxury UX
   ============================================ */

(function () {
    'use strict';

    // ═══════════════ INIT ═══════════════
    document.addEventListener('DOMContentLoaded', init);

    function init() {
        initHeroEntrance();
        initNavigation();
        initScrollReveals();
        initParallax();
        initAccordions();
        initProductGallery();
        initNewsletterForm();
        initSmoothScroll();
    }

    // ═══════════════ HERO ENTRANCE ═══════════════
    function initHeroEntrance() {
        const hero = document.querySelector('.hero');
        const nav = document.querySelector('.nav');
        if (!hero) return;

        // Trigger entrance after brief delay for page paint
        setTimeout(function () {
            hero.classList.add('hero--loaded');
            if (nav) nav.classList.add('nav--visible');
        }, 150);
    }

    // ═══════════════ NAVIGATION ═══════════════
    function initNavigation() {
        var nav = document.getElementById('mainNav');
        if (!nav) return;

        // Only dynamically toggle nav glass on pages with a hero section
        var hasHero = document.querySelector('.hero') || document.querySelector('.about-hero');
        if (!hasHero) return; // Inner pages keep their static nav--scrolled class

        var ticking = false;

        function updateNav() {
            if (window.scrollY > 80) {
                nav.classList.add('nav--scrolled');
            } else {
                nav.classList.remove('nav--scrolled');
            }
            ticking = false;
        }

        window.addEventListener('scroll', function () {
            if (!ticking) {
                requestAnimationFrame(updateNav);
                ticking = true;
            }
        }, { passive: true });
    }


    // ═══════════════ SCROLL REVEALS ═══════════════
    function initScrollReveals() {
        var elements = document.querySelectorAll('[data-reveal]');
        if (!elements.length) return;

        // Fallback for no IntersectionObserver
        if (!('IntersectionObserver' in window)) {
            elements.forEach(function (el) { el.classList.add('revealed'); });
            return;
        }

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -60px 0px'
        });

        elements.forEach(function (el) { observer.observe(el); });
    }

    // ═══════════════ PARALLAX ═══════════════
    function initParallax() {
        var elements = document.querySelectorAll('[data-parallax]');
        if (!elements.length) return;

        // Disable on mobile
        if (window.innerWidth < 768) return;

        // Check reduced motion preference
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

        var ticking = false;

        function updateParallax() {
            var scrollY = window.scrollY;

            elements.forEach(function (el) {
                var rate = parseFloat(el.getAttribute('data-parallax')) || 0.15;
                var rect = el.getBoundingClientRect();
                var centerY = rect.top + rect.height / 2;
                var viewportCenter = window.innerHeight / 2;
                var offset = (centerY - viewportCenter) * rate;

                el.style.transform = 'translateY(' + offset + 'px)';
            });

            ticking = false;
        }

        window.addEventListener('scroll', function () {
            if (!ticking) {
                requestAnimationFrame(updateParallax);
                ticking = true;
            }
        }, { passive: true });
    }

    // ═══════════════ ACCORDIONS ═══════════════
    function initAccordions() {
        var triggers = document.querySelectorAll('.accordion__trigger');
        if (!triggers.length) return;

        triggers.forEach(function (trigger) {
            trigger.addEventListener('click', function () {
                var item = trigger.closest('.accordion__item');
                var isOpen = item.classList.contains('accordion__item--open');

                // Close all siblings
                var accordion = item.closest('.accordion');
                var siblings = accordion.querySelectorAll('.accordion__item--open');
                siblings.forEach(function (sibling) {
                    sibling.classList.remove('accordion__item--open');
                });

                // Toggle current
                if (!isOpen) {
                    item.classList.add('accordion__item--open');
                }
            });
        });
    }


    // ═══════════════ PRODUCT GALLERY ═══════════════
    function initProductGallery() {
        var thumbs = document.querySelectorAll('.product-gallery__thumb');
        var mainImage = document.querySelector('.product-gallery__main img');
        if (!thumbs.length || !mainImage) return;

        thumbs.forEach(function (thumb) {
            thumb.addEventListener('click', function () {
                // Update active state
                thumbs.forEach(function (t) {
                    t.classList.remove('product-gallery__thumb--active');
                });
                thumb.classList.add('product-gallery__thumb--active');

                // Swap main image
                var newSrc = thumb.querySelector('img').getAttribute('data-full');
                if (newSrc) {
                    mainImage.style.opacity = '0';
                    setTimeout(function () {
                        mainImage.src = newSrc;
                        mainImage.style.opacity = '1';
                    }, 300);
                }
            });
        });

        // Image zoom on hover (desktop)
        var gallery = document.querySelector('.product-gallery__main');
        if (gallery && window.innerWidth > 1024) {
            gallery.addEventListener('mousemove', function (e) {
                var rect = gallery.getBoundingClientRect();
                var x = ((e.clientX - rect.left) / rect.width) * 100;
                var y = ((e.clientY - rect.top) / rect.height) * 100;
                mainImage.style.transformOrigin = x + '% ' + y + '%';
                mainImage.style.transform = 'scale(1.5)';
            });

            gallery.addEventListener('mouseleave', function () {
                mainImage.style.transformOrigin = 'center center';
                mainImage.style.transform = 'scale(1)';
            });
        }
    }

    // ═══════════════ NEWSLETTER FORM ═══════════════
    function initNewsletterForm() {
        var form = document.querySelector('.newsletter__form');
        if (!form) return;

        form.addEventListener('submit', function (e) {
            e.preventDefault();

            var input = form.querySelector('.newsletter__input');
            var email = input.value.trim();

            if (!email || !isValidEmail(email)) {
                input.style.borderColor = 'var(--color-error)';
                setTimeout(function () {
                    input.style.borderColor = '';
                }, 2000);
                return;
            }

            // Simulate success
            var submit = form.querySelector('.newsletter__submit');
            var originalText = submit.textContent;

            submit.textContent = 'Welcome';
            submit.style.background = 'var(--color-gold-light)';
            input.value = '';
            input.placeholder = 'You\'re on the list';

            setTimeout(function () {
                submit.textContent = originalText;
                submit.style.background = '';
                input.placeholder = 'Your email address';
            }, 3500);
        });
    }

    // ═══════════════ SMOOTH SCROLL ═══════════════
    function initSmoothScroll() {
        var links = document.querySelectorAll('a[href^="#"]');

        links.forEach(function (link) {
            link.addEventListener('click', function (e) {
                var href = link.getAttribute('href');
                if (href === '#' || href === '#0') return;

                var target = document.querySelector(href);
                if (!target) return;

                e.preventDefault();

                var navHeight = document.querySelector('.nav')
                    ? document.querySelector('.nav').offsetHeight
                    : 0;
                var targetPos = target.getBoundingClientRect().top + window.scrollY - navHeight - 20;

                window.scrollTo({
                    top: targetPos,
                    behavior: 'smooth'
                });
            });
        });
    }

    // ═══════════════ UTILITIES ═══════════════
    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

})();
