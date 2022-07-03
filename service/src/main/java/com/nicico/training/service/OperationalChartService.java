package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.iservice.IOperationalChartService;
import com.nicico.training.mapper.operationalChart.OperationalChartMapper;
import com.nicico.training.model.OperationalChart;
import com.nicico.training.repository.OperationalChartDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class OperationalChartService implements IOperationalChartService {
     private final OperationalChartDAO operationalChartDAO;
     private final OperationalChartMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public OperationalChartDTO.Info get(Long id) {
        final Optional<OperationalChart> gById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.OperationalChartNotFound));
        return mapper.toInfoDTO(operationalChart);
    }

    @Transactional(readOnly = true)
    @Override
    public List<OperationalChartDTO.Info> list() {
        final List<OperationalChart> gAll = operationalChartDAO.findAll();
        return mapper.toInfoDTOList(gAll);

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info create(OperationalChartDTO.Create request) {
        final OperationalChart operationalChart = mapper.toOperationalChart(request);

        final List<OperationalChart> all = operationalChartDAO.findAll();

        Set<OperationalChart> set = new HashSet<>();
        all.forEach(o -> {
                    if (o.getNationalCode().contains(operationalChart.getNationalCode())) {
                        set.add(o);
                    }
                }
        );

        if (set.stream().toList().size() == 0) {
            return save(operationalChart);
        }
         new TrainingException(TrainingException.ErrorType.OperationalChartIsDuplicated);
        return null;

    }

    @Override
    public OperationalChartDTO.Info addChild(Long parentId, Long childId)  {
        Optional<OperationalChart> findoperationalParent=  operationalChartDAO.findById(parentId);
        Optional<OperationalChart> findoperationalChild=  operationalChartDAO.findById(childId);
        Optional<OperationalChart> operationalParent= Optional.ofNullable(findoperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));
        Optional<OperationalChart> operationalChild= Optional.ofNullable(findoperationalChild.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (!operationalParent.isPresent() || !operationalChild.isPresent()){
            return null;
        }else {
            OperationalChart parent=operationalParent.get();
            OperationalChart child=operationalChild.get();

            Set<OperationalChart> lastChilds= new HashSet<>(operationalChartDAO.findAllByParentId(parentId));
            lastChilds.add(child);
            parent.setOperationalChartParentChild(lastChilds.stream().toList());
            save(parent);
            Optional<OperationalChart> savedParent=  operationalChartDAO.findById(parent.getId());

            child.setParentId(savedParent.get().getId());
            OperationalChartDTO.Info savedChild=   save(child);
            return savedChild;
        }

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
//        OperationalChart updating = new OperationalChart();
//        modelMapper.map(operationalChart, updating);
//        modelMapper.map(request, updating);
//        return save(updating);

      return save( operationalChart);


    }

    @Transactional
    @Override
    public OperationalChartDTO.Info updateParent(Long id,Long parentId, OperationalChartDTO.Update request) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        operationalChart.setParentId(parentId);
//todo set child on new parent and remove from lod parent list
        return save(operationalChart);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<OperationalChart> one = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        if (operationalChart.getOperationalChartParentChild() == null) {
            operationalChartDAO.delete(operationalChart);
        }else
        { new TrainingException(TrainingException.ErrorType.OperationalChartHasChild);}
    }

    @Transactional
    @Override
    public void delete(OperationalChartDTO.Delete request) {
        final List<OperationalChart> gAllById = operationalChartDAO.findAllById(request.getIds());
        if(  gAllById.stream().filter(parent->parent.getOperationalChartParentChild().stream().findAny().isPresent()).equals(true)  ) {
            new TrainingException(TrainingException.ErrorType.OperationalChartHasChild);
        } else

        operationalChartDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalChartDAO, request, operationalChart -> mapper.toInfoDTO(request));
    }

    private OperationalChartDTO.Info save(OperationalChart operationalChart) {
        final OperationalChart saved = operationalChartDAO.saveAndFlush(operationalChart);
        return mapper.toInfoDTO(saved);
    }
}
