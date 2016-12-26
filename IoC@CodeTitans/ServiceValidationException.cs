﻿#region License
/*
    Copyright (c) 2010, Paweł Hofman (CodeTitans)
    All Rights Reserved.

    Licensed under the Apache License version 2.0.
    For more information please visit:

    http://codetitans.codeplex.com/license
        or
    http://www.apache.org/licenses/


    For latest source code, documentation, samples
    and more information please visit:

    http://codetitans.codeplex.com/
*/
#endregion

using System;

namespace CodeTitans.Services
{
    /// <summary>
    /// Exception thrown during the service type validation.
    /// </summary>
    [Serializable]
    public sealed class ServiceValidationException : Exception
    {
        /// <summary>
        /// Default constructor.
        /// </summary>
        public ServiceValidationException()
            : base("Invalid type hierarchy")
        {
        }

        /// <summary>
        /// Init constructor.
        /// </summary>
        public ServiceValidationException(Type expectedType, Type serviceType)
            : base(string.Format("Type '{0}' is not assignable from '{1}'", expectedType != null ? expectedType.FullName : "unknown", serviceType != null ? serviceType.FullName : "unknown"))
        {
            if (expectedType == null)
                throw new ArgumentNullException("expectedType");
            if (serviceType == null)
                throw new ArgumentNullException("serviceType");

            ExpectedType = expectedType;
            ServiceType = serviceType;
        }

        #region Properties

        /// <summary>
        /// Expected type of the service.
        /// </summary>
        public Type ExpectedType
        { get; private set; }

        /// <summary>
        /// Type of the service.
        /// </summary>
        public Type ServiceType
        { get; private set; }

        #endregion
    }
}
