---
layout: post
title: "React-Redux: #1 Setup"
date: 2025-05-11 08:00:00 +0700
tags: [react, redux, frontend]
isPublished: false
---

# Module 1: Foundation & Project Setup

## Learning Objectives
By the end of this module, you will:
- Set up a React Redux project from scratch
- Implement Redux store, actions, and reducers
- Create a product listing grid with React components
- Use React Redux hooks (useSelector, useDispatch)
- Establish the foundation for the ShopHub e-commerce platform

## Feature Requirements
- Initialize ShopHub project with React and Redux
- Create a responsive product display grid
- Implement Redux store with products reducer
- Display mock product data
- Set up project structure following repository guidelines

## Implementation Steps

### Step 1: Project Initialization

```bash
npx create-react-app shophub
cd shophub
```

Create `package.json`:

```json
{
  "name": "shophub",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@reduxjs/toolkit": "^1.9.7",
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^8.1.3",
    "react-router-dom": "^6.16.0",
    "react-scripts": "5.0.1",
    "redux": "^4.2.1",
    "web-vitals": "^2.1.4"
  },
  "devDependencies": {
    "@tailwindcss/aspect-ratio": "^0.4.2",
    "@tailwindcss/forms": "^0.5.7",
    "autoprefixer": "^10.4.16",
    "eslint": "^8.52.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-jsx-a11y": "^6.8.0",
    "eslint-plugin-react": "^7.33.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "postcss": "^8.4.31",
    "prettier": "^3.0.3",
    "tailwindcss": "^3.3.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix",
    "format": "prettier --write src/"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
```

Install dependencies:

```bash
npm install
```

### Step 2: Configure Tailwind CSS

Create `tailwind.config.js`:

```javascript
module.exports = {
  content: [
    "./src/**/*.{js,jsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f5f3ff',
          100: '#ede9fe',
          200: '#ddd6fe',
          300: '#c4b5fd',
          400: '#a78bfa',
          500: '#8b5cf6',
          600: '#7c3aed',
          700: '#6d28d9',
          800: '#5b21b6',
          900: '#4c1d95',
        },
        secondary: {
          50: '#fdf2f8',
          100: '#fce7f3',
          200: '#fbcfe8',
          300: '#f9a8d4',
          400: '#f472b6',
          500: '#ec4899',
          600: '#db2777',
          700: '#be185d',
          800: '#9d174d',
          900: '#831843',
        }
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
      container: {
        center: true,
        padding: {
          DEFAULT: '1rem',
          sm: '2rem',
          lg: '4rem',
          xl: '5rem',
          '2xl': '6rem',
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
```

Create `postcss.config.js`:

```javascript
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
```

Update `src/index.css`:

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Step 3: Create Project Structure

```bash
mkdir -p src/api
mkdir -p src/components/common
mkdir -p src/components/layout
mkdir -p src/components/features
mkdir -p src/pages
mkdir -p src/store/actions
mkdir -p src/store/reducers
mkdir -p src/store/selectors
mkdir -p src/store/middleware
mkdir -p src/hooks
mkdir -p src/utils
mkdir -p src/constants
mkdir -p src/styles
```

### Step 4: Configure ESLint

Create `.eslintrc.js`:

```javascript
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'prettier'
  ],
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 12,
    sourceType: 'module'
  },
  plugins: [
    'react',
    'react-hooks',
    'jsx-a11y'
  ],
  settings: {
    react: {
      version: 'detect'
    }
  },
  rules: {
    'react/prop-types': 'off',
    'react/react-in-jsx-scope': 'off',
    'react/display-name': 'off',
    'no-unused-vars': ['error', { 
      'argsIgnorePattern': '^_',
      'varsIgnorePattern': '^_'
    }],
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',
    'jsx-a11y/anchor-is-valid': 'warn',
    'no-console': ['warn', { 
      allow: ['warn', 'error'] 
    }],
    'prefer-const': 'error',
    'no-var': 'error',
    'arrow-body-style': ['error', 'as-needed'],
    'object-shorthand': 'error',
    'prefer-arrow-callback': 'error',
    'prefer-destructuring': ['error', {
      'array': true,
      'object': true
    }],
    'template-curly-spacing': ['error', 'never'],
  }
};
```

Create `.prettierrc`:

```json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "jsxSingleQuote": false,
  "bracketSpacing": true,
  "jsxBracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

### Step 5: Create Mock Data (Updated)

Create `src/api/mockData.js`:

```javascript
export const mockProducts = [
  {
    id: 1,
    name: 'Wireless Headphones',
    price: 99.99,
    image: 'https://placehold.co/300x300',
    description: 'High-quality wireless headphones with noise cancellation',
    category: 'Electronics',
    stock: 50,
    rating: 4.5,
  },
  {
    id: 2,
    name: 'Running Shoes',
    price: 79.99,
    image: 'https://placehold.co/300x300',
    description: 'Comfortable running shoes for all terrains',
    category: 'Sports',
    stock: 30,
    rating: 4.2,
  },
  {
    id: 3,
    name: 'Coffee Maker',
    price: 149.99,
    image: 'https://placehold.co/300x300',
    description: 'Programmable coffee maker with thermal carafe',
    category: 'Home & Kitchen',
    stock: 25,
    rating: 4.7,
  },
  {
    id: 4,
    name: 'Backpack',
    price: 49.99,
    image: 'https://placehold.co/300x300',
    description: 'Durable laptop backpack with multiple compartments',
    category: 'Accessories',
    stock: 40,
    rating: 4.3,
  },
  {
    id: 5,
    name: 'Smart Watch',
    price: 199.99,
    image: 'https://placehold.co/300x300',
    description: 'Fitness tracking smart watch with heart rate monitor',
    category: 'Electronics',
    stock: 15,
    rating: 4.6,
  },
  {
    id: 6,
    name: 'Yoga Mat',
    price: 29.99,
    image: 'https://placehold.co/300x300',
    description: 'Non-slip yoga mat with carrying strap',
    category: 'Sports',
    stock: 60,
    rating: 4.4,
  },
];
```

### Step 6: Create Redux Store

Create `src/store/actions/productActions.js`:

```javascript
export const productActionTypes = {
  SET_PRODUCTS: 'SET_PRODUCTS',
};

export const setProducts = (products) => ({
  type: productActionTypes.SET_PRODUCTS,
  payload: products,
});
```

Create `src/store/reducers/productReducer.js`:

```javascript
import { productActionTypes } from '../actions/productActions';

const initialState = {
  items: [],
};

const productReducer = (state = initialState, action) => {
  switch (action.type) {
    case productActionTypes.SET_PRODUCTS:
      return {
        ...state,
        items: action.payload,
      };
    default:
      return state;
  }
};

export default productReducer;
```

Create `src/store/reducers/index.js`:

```javascript
import { combineReducers } from 'redux';
import productReducer from './productReducer';

const rootReducer = combineReducers({
  products: productReducer,
});

export default rootReducer;
```

Create `src/store/index.js`:

```javascript
import { createStore } from 'redux';
import rootReducer from './reducers';

const store = createStore(
  rootReducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

export default store;
```

### Step 7: Create Layout Components

Create `src/components/layout/Header.js`:

```javascript
const Header = () => (
  <header className="bg-white shadow-sm">
    <div className="container mx-auto px-4 py-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-primary-600">ShopHub</h1>
        <nav>
          <ul className="flex space-x-6">
            <li>
              <a href="/" className="text-gray-600 hover:text-primary-600">
                Home
              </a>
            </li>
            <li>
              <a href="/products" className="text-gray-600 hover:text-primary-600">
                Products
              </a>
            </li>
            <li>
              <a href="/cart" className="text-gray-600 hover:text-primary-600">
                Cart
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </header>
);

export default Header;
```

Create `src/components/layout/Layout.js`:

```javascript
import Header from './Header';

const Layout = ({ children }) => (
  <div className="min-h-screen bg-gray-50">
    <Header />
    <main className="container mx-auto px-4 py-8">
      {children}
    </main>
  </div>
);

export default Layout;
```

### Step 8: Create Product Components

Create `src/components/features/ProductCard.js`:

```javascript
const ProductCard = ({ product }) => (
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
        <button className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors">
          Add to Cart
        </button>
      </div>
    </div>
  </div>
);

export default ProductCard;
```

Create `src/components/features/ProductGrid.js`:

```javascript
import { useSelector } from 'react-redux';
import ProductCard from './ProductCard';

const ProductGrid = () => {
  const products = useSelector(state => state.products.items);

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
};

export default ProductGrid;
```

### Step 9: Create Pages

Create `src/pages/Home.js`:

```javascript
import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import { setProducts } from '../store/actions/productActions';
import { mockProducts } from '../api/mockData';
import ProductGrid from '../components/features/ProductGrid';

const Home = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(setProducts(mockProducts));
  }, [dispatch]);

  return (
    <div>
      <h2 className="text-3xl font-bold text-gray-900 mb-8">Our Products</h2>
      <ProductGrid />
    </div>
  );
};

export default Home;
```

### Step 10: Update App Component

Update `src/App.js`:

```javascript
import { Provider } from 'react-redux';
import store from './store';
import Layout from './components/layout/Layout';
import Home from './pages/Home';

function App() {
  return (
    <Provider store={store}>
      <Layout>
        <Home />
      </Layout>
    </Provider>
  );
}

export default App;
```

### Step 11: Basic Tests

Create `src/store/reducers/productReducer.test.js`:

```javascript
import productReducer from './productReducer';
import { productActionTypes } from '../actions/productActions';

describe('productReducer', () => {
  it('should return initial state', () => {
    const state = productReducer(undefined, {});
    expect(state).toEqual({ items: [] });
  });

  it('should handle SET_PRODUCTS', () => {
    const mockProducts = [{ id: 1, name: 'Test Product' }];
    const action = {
      type: productActionTypes.SET_PRODUCTS,
      payload: mockProducts,
    };
    const state = productReducer(undefined, action);
    expect(state.items).toEqual(mockProducts);
  });
});
```

Create `src/components/features/ProductCard.test.js`:

```javascript
import { render, screen } from '@testing-library/react';
import ProductCard from './ProductCard';

describe('ProductCard', () => {
  const mockProduct = {
    id: 1,
    name: 'Test Product',
    price: 99.99,
    image: 'test.jpg',
    description: 'Test description',
    category: 'Test Category',
  };

  it('renders product information', () => {
    render(<ProductCard product={mockProduct} />);
    expect(screen.getByText('Test Product')).toBeInTheDocument();
    expect(screen.getByText('$99.99')).toBeInTheDocument();
    expect(screen.getByText('Test Category')).toBeInTheDocument();
  });
});
```

## Running the Application

```bash
npm start
```

## Module 1 Complete

You now have:
- A functional React Redux project structure
- Redux store with products reducer
- Product listing with mock data
- Responsive grid layout using Tailwind CSS
- Basic testing setup

## Connection to Module 2

In the next module, we'll add:
- Shopping cart functionality
- Redux actions for cart management
- More complex state interactions
- Component-level state management

## Exercises

1. Add a product rating display to the ProductCard component
2. Create a loading state in the products reducer
3. Implement product filtering by category
4. Add a search bar component in the Header

## Additional Resources

- [Redux Documentation](https://redux.js.org/)
- [React Redux Hooks](https://react-redux.js.org/api/hooks)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)