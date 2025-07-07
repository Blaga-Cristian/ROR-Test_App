document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.dropdown-toggle').forEach(toggle => {
    toggle.addEventListener('click', function (e) {
      e.preventDefault();
      const menu = this.nextElementSibling;
      if (menu && menu.classList.contains('dropdown-menu')) {
        menu.classList.toggle('show');
      }
    });
  });

  // Close open dropdowns when clicking elsewhere
  document.addEventListener('click', function (e) {
    document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
      if (!menu.contains(e.target) && !e.target.classList.contains('dropdown-toggle')) {
        menu.classList.remove('show');
      }
    });
  });
});

