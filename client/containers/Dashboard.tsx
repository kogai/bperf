import React, { useState, useEffect, ComponentType } from "react";
import { getItem } from "../modules/http";
import { Dashboard as Page } from "../components/pages/Dashboard";

export type Props = {};

export const Dashboard: ComponentType<Props> = params => {
  const [name, setName] = useState("empty");
  useEffect(() => {
    getItem().then(({ a }) => {
      setName(a);
    });
  }, []);

  return <Page name={name} />;
};
