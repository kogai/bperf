import React, { Fragment, ComponentType } from "react";
import { Link } from "react-router-dom";
import styled, { StyledComponent } from "styled-components";

export type Props = { name: JSX.Element };

export const Dashboard: ComponentType<Props> = ({ name }) => <div>{name}</div>;
