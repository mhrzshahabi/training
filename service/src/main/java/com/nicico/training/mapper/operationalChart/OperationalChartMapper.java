package com.nicico.training.mapper.operationalChart;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.model.OperationalChart;
import org.mapstruct.*;

import java.util.List;


@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface OperationalChartMapper {

    @Mapping(target = "operationalChartParentChild",source = "operationalChartParentChild",ignore = true)
    OperationalChartDTO.Info toInfoDTO(OperationalChart operationalChart);

    List<OperationalChartDTO.Info> toInfoDTOList(List<OperationalChart> operationalCharts);

    OperationalChart toUpdate(@MappingTarget  OperationalChart operationalChart , OperationalChartDTO.Update update);

    OperationalChart toOperationalChart (OperationalChartDTO.Create create);

    OperationalChartDTO.Info toInfoDTO(SearchDTO.SearchRq request);



}
