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
using System.Globalization;

namespace CodeTitans.Helpers
{
    /// <summary>
    /// Class with numeric helper methods.
    /// </summary>
    internal static class NumericHelper
    {
        /// <summary>
        /// Tries to convert a string representation into a numeric value.
        /// </summary>
        public static bool TryParseDouble(string s, NumberStyles style, out double result)
        {
            try
            {
                result = double.Parse(s, style, CultureInfo.InvariantCulture);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }

        /// <summary>
        /// Tries to convert a string representation into a numeric value.
        /// </summary>
        public static bool TryParseDecimal(string s, NumberStyles style, out decimal result)
        {
            try
            {
                result = decimal.Parse(s, style, CultureInfo.InvariantCulture);
                return true;
            }
            catch (ArgumentException)
            {
                result = Decimal.Zero;
                return false;
            }
            catch (FormatException)
            {
                result = Decimal.Zero;
                return false;
            }
            catch (OverflowException)
            {
                result = Decimal.Zero;
                return false;
            }
        }

        public static bool TryParseInt32(string s, out Int32 result)
        {
            try
            {
                result = Int32.Parse(s);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }

        public static bool TryParseUInt32(string s, out UInt32 result)
        {
            try
            {
                result = UInt32.Parse(s);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }

        public static bool TryParseInt64(string s, out Int64 result)
        {
            try
            {
                result = Int64.Parse(s);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }

        public static bool TryParseUInt64(string s, out UInt64 result)
        {
            try
            {
                result = UInt64.Parse(s);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }

        public static bool TryParseHexInt32(string s, out Int32 result)
        {
            try
            {
                result = int.Parse(s, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                return true;
            }
            catch (ArgumentException)
            {
                result = 0;
                return false;
            }
            catch (FormatException)
            {
                result = 0;
                return false;
            }
            catch (OverflowException)
            {
                result = 0;
                return false;
            }
        }
    }
}
