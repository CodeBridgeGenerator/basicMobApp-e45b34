import React from "react";
import { Route, Routes } from "react-router-dom";
import { connect } from "react-redux";
import ProtectedRoute from "./ProtectedRoute";

import SingleProductsPage from "../components/app_components/ProductsPage/SingleProductsPage";
import ProductProjectLayoutPage from "../components/app_components/ProductsPage/ProductProjectLayoutPage";
import SingleOrdersPage from "../components/app_components/OrdersPage/SingleOrdersPage";
import OrderProjectLayoutPage from "../components/app_components/OrdersPage/OrderProjectLayoutPage";
import SingleCustomersPage from "../components/app_components/CustomersPage/SingleCustomersPage";
import CustomerProjectLayoutPage from "../components/app_components/CustomersPage/CustomerProjectLayoutPage";
import SingleItemsPage from "../components/app_components/ItemsPage/SingleItemsPage";
import ItemProjectLayoutPage from "../components/app_components/ItemsPage/ItemProjectLayoutPage";
//  ~cb-add-import~

const AppRouter = () => {
  return (
    <Routes>
      {/* ~cb-add-unprotected-route~ */}
      <Route element={<ProtectedRoute redirectPath={"/login"} />}>
        
<Route path="/products/:singleProductsId" exact element={<SingleProductsPage />} />
<Route path="/products" exact element={<ProductProjectLayoutPage />} />
<Route path="/orders/:singleOrdersId" exact element={<SingleOrdersPage />} />
<Route path="/orders" exact element={<OrderProjectLayoutPage />} />
<Route path="/customers/:singleCustomersId" exact element={<SingleCustomersPage />} />
<Route path="/customers" exact element={<CustomerProjectLayoutPage />} />
<Route path="/items/:singleItemsId" exact element={<SingleItemsPage />} />
<Route path="/items" exact element={<ItemProjectLayoutPage />} />
        {/* ~cb-add-protected-route~ */}
      </Route>
    </Routes>
  );
};

const mapState = (state) => {
  const { isLoggedIn } = state.auth;
  return { isLoggedIn };
};
const mapDispatch = (dispatch) => ({
  alert: (data) => dispatch.toast.alert(data),
});

export default connect(mapState, mapDispatch)(AppRouter);
