/*
 * Copyright 2018 Fluence Labs Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use ethkey::Secret;

/// Authorization to call contract methods
#[derive(Debug, Clone)]
pub enum Credentials {
    No,
    Password(String),
    Secret(Secret),
}

impl Credentials {
    /// usage of secret key is priority
    pub fn get(secret: Option<Secret>, password: Option<String>) -> Credentials {
        match (secret, password) {
            (Some(secret), _) => Credentials::Secret(secret),
            (_, password) => Credentials::from_password(password),
        }
    }

    pub fn from_password(pass: Option<String>) -> Credentials {
        match pass {
            Some(p) => Credentials::Password(p.to_owned()),
            None => Credentials::No,
        }
    }
}