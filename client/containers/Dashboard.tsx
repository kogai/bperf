import React, { useState, useEffect, ComponentType } from "react";
import { getItem } from "../modules/http";
import { Dashboard as Page } from "../components/pages/Dashboard";

export type Props = {};

export const Dashboard: ComponentType<Props> = params => {
  const [name, setName] = useState(<div>Empty</div>);
  useEffect(() => {
    getItem().then(({ a }) => {
      setName(
        <React.Fragment>
          {a
            .repeat(2 ^ 32)
            .split("")
            .map((t, i) => (
              <div key={i}>{`${t}=${i}`}</div>
            ))}
        </React.Fragment>
      );
    });
  }, []);

  return <Page name={name} />;
};
