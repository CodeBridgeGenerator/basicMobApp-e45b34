import React from "react";
import { render, screen } from "@testing-library/react";

import OrdersPage from "../OrdersPage";
import { MemoryRouter } from "react-router-dom";
import "@testing-library/jest-dom";
import { init } from "@rematch/core";
import { Provider } from "react-redux";
import * as models from "../../../../models";

test("renders orders page", async () => {
    const store = init({ models });
    render(
        <Provider store={store}>
            <MemoryRouter>
                <OrdersPage />
            </MemoryRouter>
        </Provider>
    );
    expect(screen.getByRole("orders-datatable")).toBeInTheDocument();
    expect(screen.getByRole("orders-add-button")).toBeInTheDocument();
});
