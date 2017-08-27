/*
 * Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import PropTypes from 'prop-types';
import React, {Component} from 'react';
import FlatButton from 'material-ui/FlatButton';
import {TableHeaderColumn} from 'material-ui/Table';

/**
 * Data Table header component.
 * This component creates the header elements of the table.
 * */
class DataTableHeader extends Component {

    constructor() {
        super();
    }

    /**
     * The onClick function of the table header.
     * Invokes the function passed in the header object.
     * */
    _tableHeaderClick() {
        this.props.header.sort();
    }

    render() {
        let headerCell = null;

        /**
         * If the header is sortable, create a button with onClick handler.
         * else create a span element with label as the table header.
         * */
        if (this.props.header.sortable) {
            headerCell = <FlatButton label={this.props.header.label}
                                    onClick={this._tableHeaderClick.bind(this)}
                                    style={{color: '#bdbdbd'}}/>;
        } else {
            headerCell = <span style={{position: 'relative',
                paddingLeft: '16px',
                paddingRight: '16px',
                textTransform: 'uppercase',
                fontWeight: 'normal',
                color: '#bdbdbd',
                fontSize: '14px'}}>{this.props.header.label}</span>;
        }

        return (
            <TableHeaderColumn style={{paddingLeft: '0px'}} key={this.props.header.id}>
                {headerCell}
            </TableHeaderColumn>
        );
    }
}

DataTableHeader.prototypes = {
    header: PropTypes.object
};

export default DataTableHeader;
