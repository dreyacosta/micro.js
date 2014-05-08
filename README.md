# micro.js
### A tiny library for managing the DOM on modern browsers

## Usage

### DOM Ready
```js
u(function() {
  console.log('DOM is ready');
});
```

### Selectors
```js
u('section');
u('#posts');
u('.box');
```

### Append and prepend
```html
<section id="posts">
  <div>Lorem ipsum</div>
</section>
```

```js
u(function() {
  var newElement = document.createElement('div');
  newElement.innerHTML = 'New message';

  u('#posts').append(newElement);
  u('#posts').prepend(newElement);
});
```

### HTML
```html
<section id="posts">
  <div>Lorem ipsum</div>
</section>
```

```js
u(function() {
  u('#posts').html('New message');
});
```

### Events
```html
<button>Say hello</button>
```

```js
u(function() {
  var sayHello = function() {
    console.log('Hello World');
  };

  u('button').on('click', sayHello);
  u('button').off('click', sayHello);
});
```

### AJAX
```js
  /**
   * Defaults settings:
      type: 'GET'
      async: true
      success: (res) ->
      error: (res) ->
      contentType : 'application/json'
      headers: {}
      crossDomain: false
      timeout: 0
   */
  u.ajax({
    type: 'GET',
    url: 'http://localhost:3000/movies',
    success: function(res) {
      console.log('AJAX success response', res);
    },
    error: function(res) {
      console.log('AJAX error response', res);
    }
  });

  u.ajax({
    type: 'POST',
    url: 'http://localhost:3000/movies',
    data: {title: 'Lorem', description: 'Ipsum'},
    success: function(res) {
      console.log('AJAX success response', res);
    },
    error: function(res) {
      console.log('AJAX error response', res);
    }
  });

  // FORM DATA
  var formData = new FormData();
  formData.append('title', 'Lorem');
  formData.append('description', 'Ipsum');

  u.ajax({
    type: 'POST',
    url: 'http://localhost:3000/movies',
    contentType: false,
    data: formData,
    success: function(res) {
      console.log('AJAX success response', res);
    },
    error: function(res) {
      console.log('AJAX error response', res);
    }
  });
```