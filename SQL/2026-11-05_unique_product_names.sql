SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    ;WITH DuplicateNames AS
    (
        SELECT LTRIM(RTRIM(Name)) AS BaseName
        FROM dbo.Product
        WHERE Name IS NOT NULL AND LTRIM(RTRIM(Name)) <> N''
        GROUP BY LTRIM(RTRIM(Name))
        HAVING COUNT(*) > 1
    )
    UPDATE product
    SET Name = LEFT(
            LTRIM(RTRIM(product.Name)),
            100 - LEN(N' #' + CONVERT(nvarchar(10), product.ProductId))
        ) + N' #' + CONVERT(nvarchar(10), product.ProductId)
    FROM dbo.Product AS product
    INNER JOIN DuplicateNames AS duplicate
        ON LTRIM(RTRIM(product.Name)) = duplicate.BaseName;

    DECLARE @UpdatedRows int = @@ROWCOUNT;

    IF EXISTS
    (
        SELECT LTRIM(RTRIM(Name))
        FROM dbo.Product
        WHERE Name IS NOT NULL AND LTRIM(RTRIM(Name)) <> N''
        GROUP BY LTRIM(RTRIM(Name))
        HAVING COUNT(*) > 1
    )
    BEGIN
        THROW 50001, 'Product names are still duplicated after the update.', 1;
    END;

    COMMIT TRANSACTION;

    SELECT @UpdatedRows AS UpdatedProducts;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
