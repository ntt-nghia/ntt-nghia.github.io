---
layout: post
title: "React-Redux: #2 Cart"
date: 2025-05-11 08:00:00 +0700
tags: [react, redux, frontend]
isPublished: false
---

## Module 2: State Management Basics - Final Version

### Learning Objectives

By the end of this module, you'll understand:
- How to implement CRUD operations in Redux
- The distinction between component-level and application-level state
- Proper patterns for managing shopping cart state
- Action creator patterns and naming conventions
- Reducer composition techniques
- How to use Redux DevTools effectively
- Integration of React Router with Redux

### Feature Requirements

We'll build these features on top of our existing product grid:
1. Shopping cart with add/remove functionality
2. Cart item quantity management (increment/decrement)
3. Real-time cart total calculation
4. Cart summary in the header
5. Dedicated cart page with full cart management
6. Navigation between pages using React Router

### Implementation Steps

#### Step 1: Install Required Dependencies

```bash
npm install react-router-dom @heroicons/react
```

#### Step 2: Cart Actions and Action Types

Create `src/store/actions/cartActions.js`:

```javascript
export const cartActionTypes = {
  ADD_TO_CART: 'ADD_TO_CART',
  REMOVE_FROM_CART: 'REMOVE_FROM_CART',
  UPDATE_QUANTITY: 'UPDATE_QUANTITY',
  CLEAR_CART: 'CLEAR_CART',
};

export const addToCart = (product) => ({
  type: cartActionTypes.ADD_TO_CART,
  payload: product,
});

export const removeFromCart = (productId) => ({
  type: cartActionTypes.REMOVE_FROM_CART,
  payload: productId,
});

export const updateQuantity = (productId, quantity) => ({
  type: cartActionTypes.UPDATE_QUANTITY,
  payload: { productId, quantity },
});

export const clearCart = () => ({
  type: cartActionTypes.CLEAR_CART,
});
```

#### Step 3: Cart Reducer

Create `src/store/reducers/cartReducer.js`:

```javascript
import { cartActionTypes } from '../actions/cartActions';

const initialState = {
  items: [],
  total: 0,
};

const calculateTotal = (items) => {
  return items.reduce((total, item) => total + item.price * item.quantity, 0);
};

const cartReducer = (state = initialState, action) => {
  switch (action.type) {
    case cartActionTypes.ADD_TO_CART: {
      const existingItemIndex = state.items.findIndex(
        (item) => item.id === action.payload.id
      );

      let updatedItems;
      if (existingItemIndex >= 0) {
        updatedItems = state.items.map((item, index) =>
          index === existingItemIndex
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      } else {
        updatedItems = [...state.items, { ...action.payload, quantity: 1 }];
      }

      return {
        ...state,
        items: updatedItems,
        total: calculateTotal(updatedItems),
      };
    }

    case cartActionTypes.REMOVE_FROM_CART: {
      const filteredItems = state.items.filter(
        (item) => item.id !== action.payload
      );
      return {
        ...state,
        items: filteredItems,
        total: calculateTotal(filteredItems),
      };
    }

    case cartActionTypes.UPDATE_QUANTITY: {
      const { productId, quantity } = action.payload;
      
      if (quantity === 0) {
        const filteredItems = state.items.filter(
          (item) => item.id !== productId
        );
        return {
          ...state,
          items: filteredItems,
          total: calculateTotal(filteredItems),
        };
      }

      const updatedItems = state.items.map((item) =>
        item.id === productId ? { ...item, quantity } : item
      );

      return {
        ...state,
        items: updatedItems,
        total: calculateTotal(updatedItems),
      };
    }

    case cartActionTypes.CLEAR_CART:
      return initialState;

    default:
      return state;
  }
};

export default cartReducer;
```

#### Step 4: Update Root Reducer

Update `src/store/reducers/index.js`:

```javascript
import { combineReducers } from 'redux';
import productReducer from './productReducer';
import cartReducer from './cartReducer';

const rootReducer = combineReducers({
  products: productReducer,
  cart: cartReducer,
});

export default rootReducer;
```

#### Step 5: Update App.js with React Router

Update `src/App.js`:

```javascript
import { Provider } from 'react-redux';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import store from './store';
import Layout from './components/layout/Layout';
import Home from './pages/Home';
import Cart from './pages/Cart';

function App() {
  return (
    <Provider store={store}>
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/cart" element={<Cart />} />
          </Routes>
        </Layout>
      </Router>
    </Provider>
  );
}

export default App;
```

#### Step 6: Update ProductCard with Cart Functionality

Update `src/components/features/ProductCard.js`:

```javascript
import { useDispatch } from 'react-redux';
import { addToCart } from '../../store/actions/cartActions';

const ProductCard = ({ product }) => {
  const dispatch = useDispatch();
  
  const handleAddToCart = () => {
    dispatch(addToCart(product));
  };
  
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <div className="aspect-w-1 aspect-h-1">
        <img
          src={product.image}
          alt={product.name}
          className="w-full h-full object-cover"
        />
      </div>
      <div className="p-4">
        <h3 className="text-lg font-semibold text-gray-900">{product.name}</h3>
        <p className="text-sm text-gray-500 mt-1">{product.category}</p>
        <p className="text-gray-600 mt-2 line-clamp-2">{product.description}</p>
        <div className="mt-4 flex items-center justify-between">
          <span className="text-xl font-bold text-primary-600">
            ${product.price}
          </span>
          <button 
            onClick={handleAddToCart}
            className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProductCard;
```

#### Step 7: Create CartSummary Component

Create `src/components/features/cart/CartSummary.js`:

```javascript
import { useSelector } from 'react-redux';
import { Link } from 'react-router-dom';
import { ShoppingCartIcon } from '@heroicons/react/24/outline';

const CartSummary = () => {
  const { items, total } = useSelector(state => state.cart);
  const itemCount = items.reduce((sum, item) => sum + item.quantity, 0);

  return (
    <div className="relative">
      <Link 
        to="/cart" 
        className="flex items-center text-gray-600 hover:text-primary-600"
      >
        <ShoppingCartIcon className="h-6 w-6" />
        <span className="ml-2">${total.toFixed(2)}</span>
        {itemCount > 0 && (
          <span className="absolute -top-2 -right-2 bg-primary-600 text-white rounded-full h-5 w-5 flex items-center justify-center text-xs">
            {itemCount}
          </span>
        )}
      </Link>
    </div>
  );
};

export default CartSummary;
```

#### Step 8: Update Header with React Router

Update `src/components/layout/Header.js`:

```javascript
import { Link } from 'react-router-dom';
import CartSummary from '../features/cart/CartSummary';

const Header = () => (
  <header className="bg-white shadow-sm">
    <div className="container mx-auto px-4 py-4">
      <div className="flex items-center justify-between">
        <Link to="/" className="text-2xl font-bold text-primary-600">
          ShopHub
        </Link>
        <nav className="flex items-center space-x-6">
          <ul className="flex space-x-6">
            <li>
              <Link to="/" className="text-gray-600 hover:text-primary-600">
                Home
              </Link>
            </li>
            <li>
              <Link to="/products" className="text-gray-600 hover:text-primary-600">
                Products
              </Link>
            </li>
          </ul>
          <CartSummary />
        </nav>
      </div>
    </div>
  </header>
);

export default Header;
```

#### Step 9: Create CartItem Component

Create `src/components/features/cart/CartItem.js`:

```javascript
import { useDispatch } from 'react-redux';
import { removeFromCart, updateQuantity } from '../../../store/actions/cartActions';
import { MinusIcon, PlusIcon, TrashIcon } from '@heroicons/react/24/outline';

const CartItem = ({ item }) => {
  const dispatch = useDispatch();

  const handleQuantityChange = (newQuantity) => {
    if (newQuantity >= 0) {
      dispatch(updateQuantity(item.id, newQuantity));
    }
  };

  const handleRemove = () => {
    dispatch(removeFromCart(item.id));
  };

  return (
    <div className="flex items-center p-4 bg-white rounded-lg shadow-sm">
      <img
        src={item.image}
        alt={item.name}
        className="w-20 h-20 object-cover rounded-md"
      />
      <div className="ml-4 flex-1">
        <h3 className="text-lg font-semibold text-gray-900">{item.name}</h3>
        <p className="text-gray-600">${item.price}</p>
      </div>
      <div className="flex items-center space-x-4">
        <div className="flex items-center border rounded-md">
          <button
            onClick={() => handleQuantityChange(item.quantity - 1)}
            className="p-2 hover:bg-gray-100"
          >
            <MinusIcon className="h-4 w-4" />
          </button>
          <span className="px-4 py-2">{item.quantity}</span>
          <button
            onClick={() => handleQuantityChange(item.quantity + 1)}
            className="p-2 hover:bg-gray-100"
          >
            <PlusIcon className="h-4 w-4" />
          </button>
        </div>
        <div className="text-lg font-semibold text-gray-900">
          ${(item.price * item.quantity).toFixed(2)}
        </div>
        <button
          onClick={handleRemove}
          className="p-2 text-red-600 hover:bg-red-50 rounded"
        >
          <TrashIcon className="h-5 w-5" />
        </button>
      </div>
    </div>
  );
};

export default CartItem;
```

#### Step 10: Create Cart Page

Create `src/pages/Cart.js`:

```javascript
import { useSelector, useDispatch } from 'react-redux';
import { Link } from 'react-router-dom';
import CartItem from '../components/features/cart/CartItem';
import { clearCart } from '../store/actions/cartActions';

const Cart = () => {
  const dispatch = useDispatch();
  const { items, total } = useSelector(state => state.cart);

  const handleClearCart = () => {
    dispatch(clearCart());
  };

  if (items.length === 0) {
    return (
      <div className="text-center py-12">
        <h2 className="text-2xl font-semibold text-gray-900 mb-4">
          Your Cart is Empty
        </h2>
        <p className="text-gray-600 mb-8">
          Add some products to your cart to see them here.
        </p>
        <Link 
          to="/" 
          className="inline-block bg-primary-600 text-white px-6 py-3 rounded-md hover:bg-primary-700"
        >
          Continue Shopping
        </Link>
      </div>
    );
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h2 className="text-3xl font-bold text-gray-900">Shopping Cart</h2>
        <button
          onClick={handleClearCart}
          className="text-red-600 hover:text-red-700"
        >
          Clear Cart
        </button>
      </div>
      
      <div className="space-y-4 mb-8">
        {items.map(item => (
          <CartItem key={item.id} item={item} />
        ))}
      </div>
      
      <div className="bg-white p-6 rounded-lg shadow-sm">
        <div className="flex justify-between items-center text-xl font-semibold">
          <span>Total:</span>
          <span>${total.toFixed(2)}</span>
        </div>
        <button className="w-full mt-4 bg-primary-600 text-white py-3 rounded-md hover:bg-primary-700">
          Proceed to Checkout
        </button>
      </div>
    </div>
  );
};

export default Cart;
```

### Testing Requirements

Create `src/store/reducers/cartReducer.test.js`:

```javascript
import cartReducer from './cartReducer';
import { cartActionTypes } from '../actions/cartActions';

describe('cartReducer', () => {
  const initialState = {
    items: [],
    total: 0,
  };

  it('should return initial state', () => {
    expect(cartReducer(undefined, {})).toEqual(initialState);
  });

  it('should handle ADD_TO_CART for new item', () => {
    const product = { id: 1, name: 'Test Product', price: 10 };
    const action = {
      type: cartActionTypes.ADD_TO_CART,
      payload: product,
    };
    
    const newState = cartReducer(initialState, action);
    expect(newState.items).toHaveLength(1);
    expect(newState.items[0]).toEqual({ ...product, quantity: 1 });
    expect(newState.total).toBe(10);
  });

  it('should handle ADD_TO_CART for existing item', () => {
    const state = {
      items: [{ id: 1, name: 'Test Product', price: 10, quantity: 1 }],
      total: 10,
    };
    const action = {
      type: cartActionTypes.ADD_TO_CART,
      payload: { id: 1, name: 'Test Product', price: 10 },
    };
    
    const newState = cartReducer(state, action);
    expect(newState.items[0].quantity).toBe(2);
    expect(newState.total).toBe(20);
  });

  it('should handle REMOVE_FROM_CART', () => {
    const state = {
      items: [{ id: 1, name: 'Test Product', price: 10, quantity: 1 }],
      total: 10,
    };
    const action = {
      type: cartActionTypes.REMOVE_FROM_CART,
      payload: 1,
    };
    
    const newState = cartReducer(state, action);
    expect(newState.items).toHaveLength(0);
    expect(newState.total).toBe(0);
  });

  it('should handle UPDATE_QUANTITY', () => {
    const state = {
      items: [{ id: 1, name: 'Test Product', price: 10, quantity: 1 }],
      total: 10,
    };
    const action = {
      type: cartActionTypes.UPDATE_QUANTITY,
      payload: { productId: 1, quantity: 3 },
    };
    
    const newState = cartReducer(state, action);
    expect(newState.items[0].quantity).toBe(3);
    expect(newState.total).toBe(30);
  });

  it('should handle CLEAR_CART', () => {
    const state = {
      items: [
        { id: 1, name: 'Product 1', price: 10, quantity: 2 },
        { id: 2, name: 'Product 2', price: 20, quantity: 1 }
      ],
      total: 40,
    };
    const action = { type: cartActionTypes.CLEAR_CART };
    
    const newState = cartReducer(state, action);
    expect(newState).toEqual(initialState);
  });

  it('should remove item when quantity is updated to 0', () => {
    const state = {
      items: [{ id: 1, name: 'Test Product', price: 10, quantity: 1 }],
      total: 10,
    };
    const action = {
      type: cartActionTypes.UPDATE_QUANTITY,
      payload: { productId: 1, quantity: 0 },
    };
    
    const newState = cartReducer(state, action);
    expect(newState.items).toHaveLength(0);
    expect(newState.total).toBe(0);
  });
});
```

### Project Structure After Module 2

```
src/
├── components/
│   ├── features/
│   │   ├── cart/
│   │   │   ├── CartItem.js
│   │   │   └── CartSummary.js
│   │   ├── ProductCard.js
│   │   └── ProductGrid.js
│   └── layout/
│       ├── Header.js
│       └── Layout.js
├── pages/
│   ├── Cart.js
│   └── Home.js
├── store/
│   ├── actions/
│   │   ├── cartActions.js
│   │   └── productActions.js
│   ├── reducers/
│   │   ├── cartReducer.js
│   │   ├── cartReducer.test.js
│   │   ├── productReducer.js
│   │   ├── productReducer.test.js
│   │   └── index.js
│   └── index.js
├── App.js
├── index.js
└── index.css
```

### Connection to Other Modules

**From Module 1:**
- Uses the existing product display structure
- Builds on the basic Redux setup
- Extends the mock product data

**To Module 3:**
- The synchronous cart actions prepare students for async patterns
- The reducer structure will be extended for loading/error states
- The cart functionality will integrate with API calls in Module 3

### Key Learning Points

1. **State Shape Design**: The cart state has a flat structure with calculated totals
2. **Action Patterns**: Consistent naming and payload structures  
3. **Reducer Logic**: Pure functions with immutable updates
4. **Derived State**: Calculating totals from items rather than storing separately
5. **Component Integration**: Using `useSelector` and `useDispatch` hooks effectively
6. **React Router Integration**: Proper navigation between pages in a Redux app

### Exercises for Students

1. Add a "favorites" feature using similar Redux patterns
2. Implement cart persistence using localStorage
3. Add input validation for quantity updates
4. Create a mini cart dropdown in the header
5. Add unit tests for cart actions
6. Add animation to cart item count updates
7. Implement stock checking before adding to cart

This module establishes the core Redux CRUD patterns that will be used throughout the rest of the course while introducing practical e-commerce functionality that students can relate to.