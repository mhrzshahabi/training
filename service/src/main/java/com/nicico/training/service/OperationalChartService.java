package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.IOperationalChartService;
import com.nicico.training.model.Country;
import com.nicico.training.model.OperationalChart;
import com.nicico.training.repository.OperationalChartDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class OperationalChartService implements IOperationalChartService {
    private final ModelMapper modelMapper;
    private final OperationalChartDAO operationalChartDAO;

    @Transactional(readOnly = true)
    @Override
    public OperationalChartDTO.Info get(Long id) {
        final Optional<OperationalChart> gById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.OperationalChartNotFound));
        return modelMapper.map(operationalChart, OperationalChartDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<OperationalChartDTO.Info> list() {
        final List<OperationalChart> gAll = operationalChartDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<OperationalChartDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public OperationalChartDTO.Info create(OperationalChartDTO.Create request) {
        final OperationalChart operationalChart = modelMapper.map(request, OperationalChart.class);
        return save(operationalChart);

    }

    @Override
    public OperationalChartDTO.Info addChild(OperationalChartDTO.Create request) {

       Long parentId = operationalChartDAO.findById(request.getParentId()).get().getId();
        if(parentId!=null) {
            final OperationalChart operationalChart = modelMapper.map(request, OperationalChart.class);
            return save(operationalChart);
        } else {
//            OperationalChartDTO.Info savedOperationalChart =save(operationalChart);
//
//            Set<OperationalChart> childsToSave = (Set<OperationalChart>) operationalChart.getOperationalChartParentChild();
//            if(childsToSave != null) {
//                List<OperationalChart> childs = new ArrayList<>();
//
//
//                for (OperationalChart childToSave : childsToSave) {
//                    childToSave.setParentId(savedOperationalChart.getId());
//                    save(childToSave);
//                    childs.add(childToSave);
//                }
//                savedOperationalChart.setOperationalChartParentChild(childs);
//            }
            return null;
        }


    }

    @Transactional
    @Override
    public OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        OperationalChart updating = new OperationalChart();
        modelMapper.map(operationalChart, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<OperationalChart> one = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        operationalChartDAO.delete(operationalChart);
    }

    @Transactional
    @Override
    public void delete(OperationalChartDTO.Delete request) {
        final List<OperationalChart> gAllById = operationalChartDAO.findAllById(request.getIds());
        operationalChartDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalChartDAO, request, operationalChart -> modelMapper.map(operationalChart, OperationalChartDTO.Info.class));
    }

    private OperationalChartDTO.Info save(OperationalChart operationalChart) {
        final OperationalChart saved = operationalChartDAO.saveAndFlush(operationalChart);
        return modelMapper.map(saved, OperationalChartDTO.Info.class);
    }
}
