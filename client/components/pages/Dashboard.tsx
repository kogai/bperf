import React, { Fragment, ComponentType } from "react";
import { Link } from "react-router-dom";
import styled, { StyledComponent } from "styled-components";

export type Props = { name: string };

export const Dashboard: ComponentType<Props> = ({ name }) => <div>{name}</div>;
