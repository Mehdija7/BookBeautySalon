using System;
using System.Collections.Generic;

namespace bookBeauty.Services.Database;

public partial class RecommendResult
{
    public int RecommendResultId { get; set; }

    public string? ProductId { get; set; }

    public string? FirstProductId { get; set; }

    public string? SecondProductId { get; set; }

    public string? ThirdProductId { get; set; }
}
