package com.nicico.training.mapper.operationalChart;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.OperationalChart;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;


import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface OperationalChartMapper {

    @Mapping(target = "operationalChartParentChild",source = "operationalChartParentChild",ignore = true)
    OperationalChartDTO.Info toInfoDTO(OperationalChart operationalChart);

    List<OperationalChartDTO.Info> toInfoDTOList(List<OperationalChart> operationalCharts);

    OperationalChart toOperationalChart(OperationalChartDTO.Info info);

    OperationalChart toOperationalChart (OperationalChartDTO.Create create);

    OperationalChartDTO.Info toInfoDTO(SearchDTO.SearchRq request);



}
