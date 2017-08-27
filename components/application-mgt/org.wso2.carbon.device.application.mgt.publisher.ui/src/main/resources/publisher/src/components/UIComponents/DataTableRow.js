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
import {TableRow, TableRowColumn} from 'material-ui/Table';

/**
 * Data table row component.
 * This component created a row in the data table according to the props.
 * */
class DataTableRow extends Component {

    constructor() {
        super();
        this.state = {
            dataItem: {}
        }
    }

    componentWillMount() {
        this.setState({dataItem: this.props.dataItem})
    }

    _handleClick() {
        this.props.handleClick(this.state.dataItem.id);
    }

    render() {
        const {dataItem} = this.state;
        return (
                <TableRow onClick={this._handleClick.bind(this)} >
                    {Object.keys(dataItem).map((key) => {
                        if (key !== 'id') {
                            return <TableRowColumn style={{alignItems: 'center'}} key={key}>{dataItem[key]}</TableRowColumn>
                        } else {
                            return <TableRowColumn/>
                        }

                    } )}
                </TableRow>
        );
    }
}

DataTableRow.propTypes = {
    onClick: PropTypes.func,
    data: PropTypes.object
};

export default DataTableRow;
