import React from 'react';

const AddUser = (props) => {
    return (
        <form onSubmit={(event) => props.addUser(event)}>
            <div className="field">
                <input
                    name='username'
                    className='input is-large'
                    type='text'
                    placeholder='Enter a username'
                    required
                    value={props.username}
                    onChange={props.handleChange}
                />
            </div>
            <div className="field">
                <input
                    name='email'
                    className='input is-large'
                    type='email'
                    placeholder='Enter an email'
                    required
                    value={props.email}
                    onChange={props.handleChange}
                />
            </div>
            <div className="field">
                <input
                    type='submit'
                    className='button is-primary is-large is-fullwidth'
                    value='Submit'
                />
            </div>
        </form>
    )
};

export default AddUser;
