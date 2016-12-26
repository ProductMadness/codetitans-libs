#region License
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
    /// Exception thrown when dynamic creation of the service object failed.
    /// </summary>
    [Serializable]
    public sealed class ServiceCreationException : Exception
    {
        /// <summary>
        /// Default constructor.
        /// </summary>
        public ServiceCreationException()
            : base("Unable to create service of that type")
        {
        }

        /// <summary>
        /// Init constructor.
        /// </summary>
        public ServiceCreationException(Type serviceType)
            : base(string.Format("Unable to create instance of a type '{0}'", serviceType != null ? serviceType.FullName : "unknown"))
        {
            if (serviceType == null)
                throw new ArgumentNullException("serviceType");

            ServiceType = serviceType;
        }

        #region Properties

        /// <summary>
        /// Type of the service.
        /// </summary>
        public Type ServiceType
        { get; private set; }

        #endregion
    }
}
