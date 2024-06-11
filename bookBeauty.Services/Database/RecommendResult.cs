using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class RecommendResult
{
    public int RecommendResultId { get; set; }

    public int? ProductId { get; set; }

    public int? FirstProductId { get; set; }

    public int? SecondProductId { get; set; }

    public int? ThirdProductId { get; set; }
}
