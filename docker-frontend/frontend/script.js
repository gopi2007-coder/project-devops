const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.nav');
toggle.addEventListener('click', () => {
  const open = nav.classList.toggle('open');
  toggle.setAttribute('aria-expanded', open);
  toggle.textContent = open ? 'Close' : 'Menu';
});
nav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
  nav.classList.remove('open');
  toggle.setAttribute('aria-expanded', 'false');
  toggle.textContent = 'Menu';
}));
document.querySelector('#year').textContent = new Date().getFullYear();

document.querySelectorAll('.project-details-toggle').forEach(button => {
  button.addEventListener('click', () => {
    const details = button.nextElementSibling;
    const expanded = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', String(!expanded));
    button.querySelector('span').textContent = expanded ? '+' : '−';
    details.hidden = expanded;
  });
});

document.querySelectorAll('.project').forEach(card => {
  card.addEventListener('click', event => {
    if (!event.target.closest('a, button')) {
      card.querySelector('.project-details-toggle')?.click();
    }
  });
});

document.querySelectorAll('.experience-toggle').forEach(button => {
  button.addEventListener('click', () => {
    const details = button.nextElementSibling;
    const expanded = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', String(!expanded));
    button.querySelector('span').textContent = expanded ? '+' : '−';
    details.hidden = expanded;
  });
});
