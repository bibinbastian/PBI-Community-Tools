
-- Replicating a transactional system
WHILE 1=1
BEGIN
   WAITFOR DELAY '00:00:05' -- Wait 5 seconds
  INSERT INTO dbo.FactOnlineSales
  (
      DateKey,
      StoreKey,
      ProductKey,
      PromotionKey,
      ETLLoadID,
      LoadDate,
      UpdateDate
  )
  VALUES
  (   GETDATE(), -- DateKey - datetime
      1,         -- StoreKey - int
      1,         -- ProductKey - int
      1,         -- PromotionKey - int
      NULL,      -- ETLLoadID - int
      NULL,      -- LoadDate - datetime
      NULL       -- UpdateDate - datetime
      )
END