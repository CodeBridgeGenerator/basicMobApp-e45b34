import React, { useEffect, useState } from "react";
import { connect } from "react-redux";
import { useParams } from "react-router-dom";
import client from "../../../services/restClient";
import _ from "lodash";
import initilization from "../../../utils/init";
import { Dialog } from "primereact/dialog";
import { Button } from "primereact/button";
import { InputText } from "primereact/inputtext";
import { Dropdown } from "primereact/dropdown";
import { MultiSelect } from "primereact/multiselect";


const getSchemaValidationErrorsStrings = (errorObj) => {
    let errMsg = {};
    for (const key in errorObj.errors) {
      if (Object.hasOwnProperty.call(errorObj.errors, key)) {
        const element = errorObj.errors[key];
        if (element?.message) {
          errMsg[key] = element.message;
        }
      }
    }
    return errMsg.length ? errMsg : errorObj.message ? { error : errorObj.message} : {};
};

const OrdersCreateDialogComponent = (props) => {
    const [_entity, set_entity] = useState({});
    const [error, setError] = useState({});
    const [loading, setLoading] = useState(false);
    const urlParams = useParams();
    const [customer, setCustomer] = useState([])
const [items, setItems] = useState([])

    useEffect(() => {
        let init  = {};
        if (!_.isEmpty(props?.entity)) {
            init = initilization({ ...props?.entity, ...init }, [customer,items], setError);
        }
        set_entity({...init});
        setError({});
    }, [props.show]);

    const validate = () => {
        let ret = true;
        const error = {};
          
            if (_.isEmpty(_entity?.orderNumber)) {
                error["orderNumber"] = `Order Number field is required`;
                ret = false;
            }
        if (!ret) setError(error);
        return ret;
    }

    const onSave = async () => {
        if(!validate()) return;
        let _data = {
            orderNumber: _entity?.orderNumber,customer: _entity?.customer?._id,items: _entity?.items,
            createdBy: props.user._id,
            updatedBy: props.user._id
        };

        setLoading(true);

        try {
            
        const result = await client.service("orders").create(_data);
        const eagerResult = await client
            .service("orders")
            .find({ query: { $limit: 10000 ,  _id :  { $in :[result._id]}, $populate : [
                {
                    path : "customer",
                    service : "customers",
                    select:["name"]},{
                    path : "items",
                    service : "items",
                    select:["orderNumber","customer"]}
            ] }});
        props.onHide();
        props.alert({ type: "success", title: "Create info", message: "Info Orders updated successfully" });
        props.onCreateResult(eagerResult.data[0]);
        } catch (error) {
            console.debug("error", error);
            setError(getSchemaValidationErrorsStrings(error) || "Failed to create");
            props.alert({ type: "error", title: "Create", message: "Failed to create in Orders" });
        }
        setLoading(false);
    };

    

    

    useEffect(() => {
                    // on mount customers
                    client
                        .service("customers")
                        .find({ query: { $limit: 10000, $sort: { createdAt: -1 }, _id : urlParams.singleCustomersId } })
                        .then((res) => {
                            setCustomer(res.data.map((e) => { return { name: e['name'], value: e._id }}));
                        })
                        .catch((error) => {
                            console.debug({ error });
                            props.alert({ title: "Customers", type: "error", message: error.message || "Failed get customers" });
                        });
                }, []);

useEffect(() => {
                    // on mount items
                    client
                        .service("items")
                        .find({ query: { $limit: 10000, $sort: { createdAt: -1 }, _id : urlParams.singleItemsId } })
                        .then((res) => {
                            setItems(res.data.map((e) => { return { orderNumber: `${e["orderNumber"]}`,customer: `${e["customer"]}`, value: e._id }}));
                        })
                        .catch((error) => {
                            console.debug({ error });
                            props.alert({ title: "Items", type: "error", message: error.message || "Failed get items" });
                        });
                }, []);

    const renderFooter = () => (
        <div className="flex justify-content-end">
            <Button label="save" className="p-button-text no-focus-effect" onClick={onSave} loading={loading} />
            <Button label="close" className="p-button-text no-focus-effect p-button-secondary" onClick={props.onHide} />
        </div>
    );

    const setValByKey = (key, val) => {
        let new_entity = { ..._entity, [key]: val };
        set_entity(new_entity);
        setError({});
    };

    const customerOptions = customer.map((elem) => ({ name: elem.name, value: elem.value }));
const itemsOptions = items.map((elem) => ({ name: elem.name, value: elem.value }));

    return (
        <Dialog header="Create Orders" visible={props.show} closable={false} onHide={props.onHide} modal style={{ width: "40vw" }} className="min-w-max scalein animation-ease-in-out animation-duration-1000" footer={renderFooter()} resizable={false}>
            <div className="grid p-fluid overflow-y-auto"
            style={{ maxWidth: "55vw" }} role="orders-create-dialog-component">
            <div className="col-12 md:col-6 field">
            <span className="align-items-center">
                <label htmlFor="orderNumber">Order Number:</label>
                <InputText id="orderNumber" className="w-full mb-3 p-inputtext-sm" value={_entity?.orderNumber} onChange={(e) => setValByKey("orderNumber", e.target.value)}  required  />
            </span>
            <small className="p-error">
            {!_.isEmpty(error["orderNumber"]) ? (
              <p className="m-0" key="error-orderNumber">
                {error["orderNumber"]}
              </p>
            ) : null}
          </small>
            </div>
<div className="col-12 md:col-6 field">
            <span className="align-items-center">
                <label htmlFor="customer">Customer:</label>
                <Dropdown id="customer" value={_entity?.customer?._id} optionLabel="name" optionValue="value" options={customerOptions} onChange={(e) => setValByKey("customer", {_id : e.value})}  />
            </span>
            <small className="p-error">
            {!_.isEmpty(error["customer"]) ? (
              <p className="m-0" key="error-customer">
                {error["customer"]}
              </p>
            ) : null}
          </small>
            </div>
<div className="col-12 md:col-6 field">
            <span className="align-items-center">
                <label htmlFor="items">Items:</label>
                <MultiSelect id="items" value={_entity?.items} options={itemsOptions} optionLabel="name" optionValue="value" onChange={(e) => setValByKey("items", e.value)}  />
            </span>
            <small className="p-error">
            {!_.isEmpty(error["items"]) ? (
              <p className="m-0" key="error-items">
                {error["items"]}
              </p>
            ) : null}
          </small>
            </div>
            <small className="p-error">
                {Array.isArray(Object.keys(error))
                ? Object.keys(error).map((e, i) => (
                    <p className="m-0" key={i}>
                        {e}: {error[e]}
                    </p>
                    ))
                : error}
            </small>
            </div>
        </Dialog>
    );
};

const mapState = (state) => {
    const { user } = state.auth;
    return { user };
};
const mapDispatch = (dispatch) => ({
    alert: (data) => dispatch.toast.alert(data),
});

export default connect(mapState, mapDispatch)(OrdersCreateDialogComponent);
