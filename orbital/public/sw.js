// ORBITAL service worker. It lives under /orbital/, so all paths are relative to its scope.
const CACHE = 'orbital-integrated-2d-v11';
const SCOPE = self.registration.scope;
const SHELL = ['./', './manifest.webmanifest', './icon.svg', './orbital-math.mjs', './object-details.mjs'].map(p => new URL(p, SCOPE).href);
self.addEventListener('install', event => event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(SHELL)).then(() => self.skipWaiting())));
self.addEventListener('activate', event => event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim())));
self.addEventListener('fetch', event => {
  const request = event.request, url = new URL(request.url);
  if (request.method !== 'GET' || url.pathname.startsWith('/api/')) return;
  if (url.origin === location.origin && url.href.startsWith(SCOPE)) {
    event.respondWith(caches.match(request).then(hit => hit || fetch(request).then(response => {
      if (response.ok) { const copy = response.clone(); caches.open(CACHE).then(cache => cache.put(request, copy)); }
      return response;
    }).catch(() => caches.match(SCOPE))));
  }
});
