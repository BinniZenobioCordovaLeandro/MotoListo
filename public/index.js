// Wait for the DOM to fully load
document.addEventListener('DOMContentLoaded', () => {
    // Add animation to the hero section on load
    const heroSection = document.querySelector('.hero');
    heroSection.style.opacity = 0;
    heroSection.style.transform = 'translateY(50px)';

    setTimeout(() => {
        heroSection.style.transition = 'all 1s ease';
        heroSection.style.opacity = 1;
        heroSection.style.transform = 'translateY(0)';
    }, 100);

    // Add hover animation for benefit items
    const benefitItems = document.querySelectorAll('.benefit-item');
    benefitItems.forEach((item) => {
        item.addEventListener('mouseenter', () => {
            item.style.transition = 'transform 0.3s ease';
            item.style.transform = 'scale(1.05)';
        });

        item.addEventListener('mouseleave', () => {
            item.style.transform = 'scale(1)';
        });
    });

    // Scroll animation for download buttons
    const downloadSection = document.querySelector('.download');
    const downloadObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const buttons = downloadSection.querySelectorAll('.btn');
                buttons.forEach((button, index) => {
                    setTimeout(() => {
                        button.style.opacity = 1;
                        button.style.transform = 'translateY(0)';
                    }, index * 200);
                });
            }
        });
    }, { threshold: 0.5 });

    downloadObserver.observe(downloadSection);

    // Initial style for download buttons
    const downloadButtons = document.querySelectorAll('.download-buttons .btn');
    downloadButtons.forEach(button => {
        button.style.opacity = 0;
        button.style.transform = 'translateY(20px)';
    });
});
