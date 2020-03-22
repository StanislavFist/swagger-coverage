<#ftl output_format="HTML">
<#-- @ftlvariable ftlvariable name="data" type="com.github.viclovsky.swagger.coverage.model.SwaggerCoverageResults" -->
<#import "operationData.ftl" as operationData/>
<#import "ui.ftl" as ui/>

<#macro details coverage prefix>
    <div class="accordion" id="${prefix}-accordion">
        <#list coverage as key, value>
            <div class="card">
                <div class="card-header">
                    <div class="row"
                         data-toggle="collapse"
                         data-target="#${prefix}-${key?index}"
                         aria-expanded="true"
                         aria-controls="collapseOne">
                        <div class="col-1">
                            <button type="button" class="btn btn-sm">${key.httpMethod}</button>
                        </div>
                        <div class="col-5">
                            ${key.path}
                        </div>
                    </div>
                </div>
            </div>
        </#list>
    </div>
</#macro>

<#macro conditiondetails coverage prefix>
    <div class="accordion" id="${prefix}-accordion">
        <#list coverage as key, value>
            <div class="card">
                <div class="card-header">
                    <div class="row"
                         data-toggle="collapse"
                         data-target="#${prefix}-${key?index}"
                         aria-expanded="true"
                         aria-controls="collapseOne">
                        <div class="col-1">
                            <button type="button" class="btn btn-sm">${key.httpMethod}</button>
                        </div>
                        <div class="col-4">
                            ${key.path}
                        </div>
                        <div class="col-2">
                            ${value.coveredConditionCount}/${value.allConditionCount}
                        </div>
                        <div class="col-2">
                            <#if value.conditions?size gt 0 >
                                (${100*value.coveredConditionCount/(value.allConditionCount)}%)
                            <#else>
                                (--)
                            </#if>
                        </div>
                        <div class="col-3">
                            <#if value.conditions?size gt 0 >
                                <@ui.progress current = value.coveredConditionCount full = value.allConditionCount />
                            </#if>
                        </div>
                    </div>
                </div>
                <div id="${prefix}-${key?index}" class="collapse" aria-labelledby="headingOne">
                    <@operationData.conditionList list=value.conditions />
                </div>
            </div>
        </#list>
    </div>
</#macro>

<head>
    <meta charset="utf-8">
    <title>Swagger Coverage</title>
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
            integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
          integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <style>
        .title {
            margin: 20px 0;
        }
    </style>
</head>
<body>
<div class="content">
    <div class="container">
        <section id="summary">
            <div class="row">
                <div class="col-12">
                    <h1 class="title">${data.info.getTitle()} ${data.info.getVersion()} Coverage</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-sm">
                    <div class="alert alert-primary" role="alert">
                        All: ${data.allOperationCount}
                    </div>
                </div>
                <div class="col-sm">
                    <div class="alert alert-success" role="alert">
                        Full: ${data.fullOperationCount * 100 / data.allOperationCount}%
                    </div>
                </div>
                <div class="col-sm">
                    <div class="alert alert-warning" role="alert">
                        Partial: ${data.partOperationCount * 100 / data.allOperationCount}%
                    </div>
                </div>
                <div class="col-sm">
                    <div class="alert alert-danger" role="alert">
                        Empty: ${data.emptyOperationCount * 100 / data.allOperationCount}%
                    </div>
                </div>
                <div class="col-sm">
                    <div class="alert alert-secondary" role="alert">
                        Missed: ${data.missed?size}
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-2">
                    Conditions covered:
                </div>
                <div class="col-2">
                    ${data.coveredConditionCount} / ${data.allConditionCount}
                </div>
                <div class="col-2">
                    <#if data.allConditionCount gt 0 >
                        (${100*data.coveredConditionCount/(data.allConditionCount)}%)
                    <#else>
                        (--)
                    </#if>
                </div>
                <div class="col-6">
                    <#if data.allConditionCount gt 0 >
                        <@ui.progress current = data.coveredConditionCount full = data.allConditionCount />
                    </#if>
                </div>
            </div>
        </section>
        <section id="details">
            <div class="row">
                <div class="col-12">
                    <h2 class="title">Coverage Details</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <ul class="nav nav-pills nav-fill" id="detail-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="condition-tab" data-toggle="tab" href="#condition" role="tab"
                               aria-controls="condition" aria-selected="true">
                                All: ${data.operations?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="full-tab" data-toggle="tab" href="#full" role="tab"
                               aria-controls="full" aria-selected="true">
                                Full: ${data.full?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="party-tab" data-toggle="tab" href="#party" role="tab"
                               aria-controls="party" aria-selected="true">
                                Partial: ${data.party?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="empty-tab" data-toggle="tab" href="#empty" role="tab"
                               aria-controls="empty" aria-selected="true">
                                Empty: ${data.empty?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="missed-tab" data-toggle="tab" href="#missed" role="tab"
                               aria-controls="missed" aria-selected="false">
                                Missed: ${data.missed?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="info-tab" data-toggle="tab" href="#info" role="tab"
                               aria-controls="info" aria-selected="false">
                                System info
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="col-12">
                    <div class="tab-content" id="details-content">
                        <div class="tab-pane fade show active" id="condition" role="tabpanel" aria-labelledby="condition-tab">
                            <@conditiondetails coverage=data.operations  prefix="condition"/>
                        </div>
                        <div class="tab-pane fade" id="full" role="tabpanel" aria-labelledby="full-tab">
                            <@conditiondetails coverage=data.full  prefix="full"/>
                        </div>
                        <div class="tab-pane fade" id="party" role="tabpanel" aria-labelledby="party-tab">
                            <@conditiondetails coverage=data.party  prefix="party"/>
                        </div>
                        <div class="tab-pane fade" id="empty" role="tabpanel" aria-labelledby="empty-tab">
                            <@conditiondetails coverage=data.empty  prefix="empty"/>
                        </div>
                        <div class="tab-pane fade" id="missed" role="tabpanel" aria-labelledby="missed-tab">
                            <@details coverage=data.missed prefix="missed"/>
                        </div>
                        <div class="tab-pane fade" id="info" role="tabpanel" aria-labelledby="info-tab">
                            Parsed result files: ${data.generationStatistics.resultFileCount}<br>
                            Generation time: ${data.generationStatistics.generationTime} ms
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

</body>